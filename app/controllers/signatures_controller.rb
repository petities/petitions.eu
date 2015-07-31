class SignaturesController < ApplicationController

  before_action :find_signature_by_unique_key, :only => [ :show, :confirm, :invite]
  before_action :set_signature, only: [:update]

  # GET /signatures
  # GET /signatures.json
  def index
    @page = (params[:page] || 1).to_i

    @petition = Petition.find(params[:petition_id])
    @chart_array = @petition.history_chart_json
    
    @signatures = @petition.signatures.confirmed

    @signatures_count_by_city = @signatures.group_by{|sig| sig.person_city}.map{|group| [group[0], group[1].size]}.sort_by{|group| group[1]}[0..9]

    @signatures = @signatures.paginate(page: @page, per_page: 12)

    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /signatures
  # POST /signatures.json
  def create
    @petition = Petition.find(params[:petition_id])
    @signature = @petition.new_signatures.new(signature_params)

    respond_to do |format|
      if @signature.save
        format.js { render json: { status: 'ok' } }
      else
        format.js { render json: @signature.errors, status: :unprocessable_entity }
      end
    end
  end

  def confirm
    @petition = @signature.petition

    if @signature.require_full_address? || @signature.require_person_birth_city? || @signature.require_born_at?
      @action = t('confirm.form.action.confirm')
      @url = petition_signature_confirm_submit(@signature)
    else
      confirm_signature unless @signature.confirmed

      @action = t('confirm.form.action.update')
      @url = petition_signature_path(@petition, @signature)
    end

    @remote_ip = request.remote_ip
    @remote_browser = request.env['HTTP_USER_AGENT'] unless request.env['HTTP_USER_AGENT'].blank?
  end

  def confirm_submit
    # If @signature is valid?, but not confirmed yet, confirm it. Record
    # user-agent, remote IP and increase columns signatures_count and
    # last_confirmed_at on the corresponding Petition record.
    # add: also update the active_rate_value column when signature is confirmed

    #find the petition
    @petition = @signature.petition

    confirm_signature if @petition && @signature.valid? && !@signature.confirmed?

    respond_to do |format|
      format.html { redirect_to @petition,
                    notice: 'Signature was successfully confirmed.' }
      format.json { render :show, status: :ok, location: @signature }
    end

  end

  # PATCH/PUT /signatures/1
  # PATCH/PUT /signatures/1.json
  def update
    @petition = @signature.petition

    respond_to do |format|
      if @signature.update(signature_params)
        format.html { redirect_to @petition, notice: 'Signature was successfully updated.' }
        format.json { render :show, status: :ok, location: @signature }
      else
        format.html { render :edit }
        format.json { render json: @signature.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /signatures/1
  # DELETE /signatures/1.json
  #def destroy
  #  @signature.destroy
  #  respond_to do |format|
  #    format.html { redirect_to signatures_url, notice: 'Signature was successfully destroyed.' }
  #    format.json { head :no_content }
  #  end
  #end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_signature
      @signature = Signature.find(params[:id])
      # find by unique key
    end

    def find_signature_by_unique_key
      @signature = Signature.find_by_unique_key(params[:signature_key])
      
      unless @signature
        @signature = NewSignature.find_by_unique_key(params[:signature_key])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def signature_params
      params.require(:signature).permit(
          :person_city, :person_name, :person_email, :person_street, :person_street_number, :person_born_at, :person_postalcode,
          :subscribe, :visible,
      )
    end

    def confirm_signature
      old_signature = @signature
      # create a new one..
      @signature = Signature.new(@signature.as_json)
      @signature.id = nil
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