class SignaturesController < ApplicationController
  include FindPetition

  protect_from_forgery except: :index

  before_action :find_signature_by_unique_key, only: [
    :show, :confirm, :confirm_submit, :pledge_submit, :user_update,
    :become_petition_owner]

  # allow petitioner to modify signatures
  before_action :set_signature, only: [:special_update]

  before_action :set_pledge, only: [:confirm, :confirm_submit, :pledge_submit]

  before_action :find_petition, only: [:index, :latest, :search, :create]

  skip_before_action :ensure_domain, only: [:latest]

  # GET /signatures
  # GET /signatures.json
  def index
    @all_signatures = @petition.signatures.limit(900)

    # make redis!
    @chart_data, @chart_labels = @petition.redis_history_chart_json(200)

    # redis ranking!
    # @signatures_count_by_city = @all_signatures.group_by(&:person_city)
    #                             .map { |group| [group[0], group[1].size] }
    #                             .select { |group| group[1] >= 50 }
    #                             .sort_by { |group| group[1] }[0..9]

    # @filtered_s_c_c = {}

    # @signatures_count_by_city.each do |group|
    #   city_name = group[0].downcase
    #   if @filtered_s_c_c[city_name]
    #     @filtered_s_c_c[city_name] += group[1].to_i
    #   else
    #     @filtered_s_c_c[city_name] = group[1].to_i
    #   end
    # end
    # @sorted_city_count = @filtered_s_c_c.sort_by { |_city, count| -count }

    per_page = 100

    @page = if params[:page].to_i > 0
              params[:page].to_i
            elsif params[:signature_id]
              (@all_signatures.pluck(:id).index(params[:signature_id].to_i).to_f / per_page).floor + 1
            else
              1
            end

    @signatures = @all_signatures.order(special: :desc, confirmed_at: :desc)
                                 .page(@page).per(per_page)

    respond_to :js, :html, :json
  end

  def latest
    @page = cleanup_page(params[:page])
    @signatures = @petition.signatures
                           .order(special: :desc, confirmed_at: :desc)
                           .page(@page).per(12)

    render layout: false
  end

  def search
    @query = params[:query]

    page = cleanup_page(params[:page])
    # @signatures = if @query.blank?
    #                 @petition.signatures.ordered.page(page).per(100)
    #               else
    #                 @petition.signatures.visible.where('person_name like ?', "%#{@query}%")
    #               end
    @signatures = @petition.signatures.ordered.page(page).per(100)

    respond_to :js
  end

  # POST /signatures
  # POST /signatures.json
  def create
    # try to find old signature first
    email = signature_params[:person_email]
    @signature = Signature.find_by(person_email: email, petition: @petition)

    unless @signature
      @signature = NewSignature.find_by(person_email: email, petition: @petition)
    end

    if @signature
      # we found an old signature
      # send confirmation mail again
      @signature.send(:send_confirmation_mail)
      respond_to do |format|
        format.js { render json: { status: 'ok' } }
      end
      # DONE!
      return
    else
      # no old signature found send new one
      # lets create a proper new signature
      @signature = @petition.new_signatures.new(signature_params)
      @signature.signature_remote_addr = request.remote_ip
      @signature.signature_remote_browser = request.env['HTTP_USER_AGENT'] if request.env['HTTP_USER_AGENT'].present?
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

  # get admin rights of the petition you have link for
  # def become_petition_owner
  #   @petition = @signature.petition
  #
  #   u = User.find_or_create_by(email: @signature.person_email)
  #   u.name = @signature.person_email
  #
  #   # new user?
  #   # send password instructions
  #   if u.confirmed_at.nil?
  #     u.confirmed_at = Time.now
  #     u.send_reset_password_instructions
  #   end
  #
  #   # save
  #   u.save
  #
  #   # give user admin permission
  #   u.add_role(:admin, @petition)
  #   # set petition back to live
  #   @petition.status = 'live'
  #   @petition.save
  #
  #   respond_to do |format|
  #     format.json { render :show, status: :ok }
  #     format.html do
  #       redirect_to @petition,
  #                   notice: t('confirmed.now_you_can_edit', default: 'you can manage this petition now')
  #     end
  #   end
  # end

  # get signature confirm page
  # view the details of your signature
  def confirm
    @petition = @signature.petition
    # generate the update signature url
    @url = petition_signature_confirm_submit_path(@petition, @signature.unique_key)

    # check if we are in the unconfirmed table
    if @signature.class == NewSignature

      # check if we need to have extra information
      # and inform user about it
      if @signature.require_full_address? ||
         # @signature.require_person_birth_city? ||
         @signature.require_born_at? ||
         @signature.require_person_country?

        # create the information needed messages
        @action = t('confirm.form.action.confirm_and_save')
        @message = t('confirm.form.add_information_and_confirm')
      else
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
  end

  # Add all the element_id's that need to be correct
  # highlight them in javascript
  # TODO add proper validation
  def add_check_fields
    @check_fields = []
    if @signature.require_full_address?
      new_fields = %w(
        person_street
        person_city
        person_street_number
        person_postalcode)
      @check_fields.push(*new_fields)
    end
    @check_fields.push('person_country') if @signature.require_person_country?
    @check_fields.push('person_born_at') if @signature.require_born_at?
  end

  # POST a signature update by user
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
                      notice: t('confirmed.signaturesuccessfully', default: 'signature successfully confirmed')
        end
      end
    else
      # there are errors
      # render a normal edit view
      add_check_fields
      @error_fields = @signature.errors.keys
      @url = petition_signature_confirm_submit_path(@petition, @signature.unique_key)

      respond_to do |format|
        format.json { render json: @signature.errors, status: :unprocessable_entity }
        format.html do
          render 'confirm'
        end
      end
    end
  end

  # update pledge
  def pledge_submit
    if @pledge.update(pledge_params)
      respond_to do |format|
        format.json { render :show, status: :ok }
      end
    else
      respond_to do |format|
        format.json { render json: @pledge.errors, status: :unprocessable_entity }
      end
    end
  end

  # ONLY ALLOWED FOR ADMINS
  # TO update special status of signature
  # PATCH/PUT /signatures/1
  # PATCH/PUT /signatures/1.json
  def special_update
    @petition = @signature.petition

    # only allow updates from admins
    authorize @petition

    respond_to do |format|
      if @signature.update(special_params)
        format.html { redirect_to @petition, notice: 'Signature was successfully updated.' }
        format.json { render :show, status: :ok }
      else
        format.html { redirect_to @petition, notice: 'Signature was successfully updated.' }
        format.json { render json: @signature.errors, status: :unprocessable_entity }
      end
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

  def not_found
    @vervolg = true
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_signature
    @signature = Signature.find(params[:id])
  end

  def find_signature_by_unique_key
    unique_key = params[:signature_id]
    @signature = NewSignature.find_by(unique_key: unique_key)
    @signature = Signature.find_by(unique_key: unique_key) unless @signature

    render :not_found, status: :not_found unless @signature
  end

  def set_pledge
    @signature.build_pledge unless @signature.pledge.present?
    @pledge = @signature.pledge
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def signature_params
    params.require(:signature).permit(
      :person_city, :more_information, :person_name, :person_email,
      :person_street, :person_street_number, :person_born_at, :person_postalcode,
      :person_function, :person_country, :person_famous,
      :person_street_number_suffix,
      :subscribe, :visible
    )
  end

  def special_params
    params.require(:signature).permit(:special)
  end

  def pledge_params
    params.require(:pledge).permit(
      :skill, :influence, :feedback, :money
    )
  end

  def confirm_signature
    old_signature = @signature
    # create a new signature in the signature table.
    @signature = Signature.new(
      old_signature.attributes.select { |key, _| Signature.attribute_names.include?(key) && key.to_s != 'id' }
    )

    @signature.confirmed = true
    @signature.confirmed_at = Time.now
    @signature.confirmation_remote_addr = request.remote_ip
    @signature.confirmation_remote_browser = request.env['HTTP_USER_AGENT'] unless request.env['HTTP_USER_AGENT'].blank?
    old_signature.destroy if @signature.save
  end
end
