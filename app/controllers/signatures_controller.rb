class SignaturesController < ApplicationController
  include FindPetition

  before_action :find_signature_by_unique_key, only: [:show, :confirm, :confirm_submit, :pledge_submit, :mail_submit, :user_update]

  # allow petitioner to modify signatures
  before_action :set_signature, only: [:update]


  # GET /signatures
  # GET /signatures.json
  def index
    find_petition

    @all_signatures = @petition.signatures.special

    unless request.xhr?
      @chart_array = @petition.history_chart_json
      @signatures_count_by_city = @all_signatures.group_by(&:person_city)
                                  .map { |group| [group[0], group[1].size] }
                                  .select { |group| group[1] >= 100 }
                                  .sort_by { |group| group[1] }[0..9]
      @per_page = 100
    else
      @per_page = 12
    end

    @page = if params[:page]
              params[:page].to_i
            elsif params[:signature_id]
              (@all_signatures.pluck(:id).index(params[:signature_id].to_i).to_f / @per_page).floor + 1
            else
              1
            end

    @signatures = @all_signatures.paginate(page: @page, per_page: @per_page)

    respond_to do |format|
      format.html
      format.js
      format.pdf
      format.csv
    end
  end

  def search
    #@petition = Petition.friendly.find(params[:petition_id])
    @petition = PetitionsController.send(:set_petition)

    @query = params[:query]

    @signatures = if @query.blank?
                    @petition.signatures.special.paginate(page: params[:page], per_page: 100)
                  else
                    @petition.signatures.confirmed.visible.where('person_name like ?', "%#{@query}%")
                  end

    respond_to do |format|
      format.js
    end
  end

  # POST /signatures
  # POST /signatures.json
  def create
    find_petition

    # try to find old signature first
    email = signature_params[:person_email]
    @signature = Signature.where(person_email: email, petition_id: @petition.id).first

    if not @signature
      @signature = NewSignature.where(person_email: email, petition_id: @petition.id).first
    end

    if @signature
      # we found an old signature
      # send confirmation mail again
      # to this moron :)
      @signature.send(:send_confirmation_mail)
      respond_to do |format|
        format.js { render json: { is_resend: 'true',  status: 'ok' } }
      end
      # DONE!
      return
    else
      # no old signature found send new one
      # lets create a proper new signature
      @signature = @petition.new_signatures.new(signature_params)
    end

    # respond to json request

    respond_to do |format|
      if @signature.save
        format.js { render json: { status: 'ok' } }
      else
        format.js { render json: @signature.errors, status: :unprocessable_entity }
      end
    end

  end

  # get signature confirm page
  # view the details of your signarture
  def confirm
    @petition = @signature.petition
    # generate the update sig url
    @url = petition_signature_confirm_submit_path(@petition, @signature.unique_key)

    set_pledge

    #@url = petition_signature_confirm_submit

    # check if we are in the unconfirmed table
    if @signature.class == NewSignature

      # check if we need to have extra information
      # and inform user about it
      if(@signature.require_full_address? ||
         @signature.require_person_birth_city? ||
         @signature.require_born_at? ||
         @signature.require_person_country?
       )

       # create the information needed messages
       @action = t('confirm.form.action.confirm_and_save')
       @message = t('confirm.form.add_information_and_confirm')

      else
        #signature is confirmed no extra data needed
        @signature.confirmed = true
        # we don't need extra information so everything is fine
        @message = t('confirm.form.is_confirmed_add_information')
      end
      # always move new_signature to signature
      # since the user must be real
      confirm_signature
    else
      @message = t('confirm.form.update_information')
      @action = t('confirm.form.action.add_details')
    end
    # add some javascript data to allow for data checking
    @check_fields = []
    add_check_fields
    @remote_ip = request.remote_ip
    @remote_browser = request.env['HTTP_USER_AGENT'] unless request.env['HTTP_USER_AGENT'].blank?
  end


  # Add all the element_id's that need to be correct
  # highlight them in javascript
  # TODO add proper validation
  def add_check_fields
    @check_fields = []
    if @signature.require_full_address?
      new_fields = [
        'person_street',
        'person_city',
        'person_street_number',
        'person_postalcode',
      ]
      @check_fields.push(*new_fields)
    end
    if @signature.require_person_country?
      @check_fields.push('person_country')
    end
    if @signature.require_born_at?
      @check_fields.push('person_born_at')
    end
  end

  # POST a singnature update by user
  # a save update on a signature.
  def confirm_submit

    @petition = @signature.petition

    if @petition && @signature.update(signature_params) && @signature.valid?
      # signature also passed validation
      @signature.confirmed = true

      respond_to do |format|
        format.json { render :show, status: :ok }
        format.html do
          redirect_to @petition,
                      notice: 'Signature was successfully confirmed.'
        end
      end
    else
      # there are errors
      # render a normal edit view
      @remote_ip = request.remote_ip
      @remote_browser = request.env['HTTP_USER_AGENT'] unless request.env['HTTP_USER_AGENT'].blank?
      add_check_fields
      @error_fields = @signature.errors.keys
      @url = petition_signature_confirm_submit_path(@petition, @signature.unique_key)

      set_pledge

      respond_to do |format|
        format.json { render json: @signature.errors, status: :unprocessable_entity }
        format.html do
          render 'confirm'
        end
      end
    end
  end

  def set_pledge
    @pledge = Pledge.where(signature_id: @signature.id).first
    if not @pledge
      @pledge = Pledge.new
      @pledge.signature_id = @signature.id
      @pledge.petition_id = @petition.id
    end

    @pledge_url = petition_signature_pledge_confirm_path(@petition, @signature.unique_key)

    @share_email_url = petition_signature_mail_submit_path(@petition, @signature.unique_key)
  end

  def pledge_submit
    # set petition
    @petition = @signature.petition
    # find pledge by petition_id and signature_id
    set_pledge

    # update pledge
    if @pledge.update(pledge_params)
      respond_to do |format|
        format.json { render :show, status: :ok }
      end
    else
      respond_to do |format|
        format.json { render json: @signature.errors, status: :unprocessable_entity }
      end
    end
  end

  # ONLY ALLOWED FOR ADMINS
  # NOW ANYONE CAN CHANGE SIGNATURES BY ID
  # PATCH/PUT /signatures/1
  # PATCH/PUT /signatures/1.json
  def update
    @petition = @signature.petition
    # only allow updates from
    # authorize @petition
    respond_to do |format|
      if @signature.update(signature_params)
        format.html { redirect_to @petition, notice: 'Signature was successfully updated.' }
        format.json { render :show, status: :ok, location: @signature }
      else
        # format.html { redirect_to signature_confirm(@signature.unique_key)}
        format.html { render :edit}
        format.json { render json: @signature.errors, status: :unprocessable_entity }
      end
    end
  end


  def mail_submit

    target = email_params[:share_email]

    if target.empty?
      respond_to do |format|
        format.json { render :show, status: :unprocessable_entity }
      end
      return
    end

    # do mail via sidekiq
    #SignatureMailer.share_mail(@signature, target).deliver_later
    # to test.
    SignatureMailer.share_mail(@signature, target).deliver_later

    respond_to do |format|
        format.json { render :show, status: :ok}
    end
  end

  # DELETE /signatures/1
  # DELETE /signatures/1.json
  def destroy
   @petition = @signature.petition
   # only allow deletes from owners
   authorize @petition

   @signature.destroy
   respond_to do |format|
     format.html { redirect_to signatures_url, notice: 'Signature was successfully destroyed.' }
     format.json { head :no_content }
   end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_signature
    @signature = Signature.find_by_unique_key(params[:id])
  end

  def find_signature_by_unique_key
    @signature = Signature.find_by_unique_key(params[:signature_id])

    unless @signature
      @signature = NewSignature.find_by_unique_key(params[:signature_id])
    end

  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def signature_params
    params.require(:signature).permit(
      :person_city, :person_name, :person_email, :person_street, :person_street_number, :person_born_at, :person_postalcode,
      :person_function, :person_country, :person_famous,
      :person_street_number_suffix,
      :subscribe, :visible,
    )
  end

  def pledge_params
    params.require(:pledge).permit(
      :skill, :influence, :feedback, :money, :inform_me
    )
  end

  def email_params
    params.permit(
      :share_email
    )
  end

  def confirm_signature
    old_signature = @signature
    @signature.id = nil
    # create a new signature in the signarure table.
    @signature = Signature.new(@signature.as_json)
    @signature.confirmed = true
    @signature.confirmation_remote_addr = request.remote_ip
    @signature.confirmation_remote_browser = request.env['HTTP_USER_AGENT'] unless request.env['HTTP_USER_AGENT'].blank?

    @petition.inc_signatures_count!
    @petition.update_active_rate!
    # expire_fragment @petition
    old_signature.delete
    @signature.save
  end

end
