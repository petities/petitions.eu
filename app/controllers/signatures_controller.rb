class SignaturesController < ApplicationController

  before_action :find_signature_by_unique_key, :only => [ :show, :confirm, :update, :invite]
  #before_action :set_signature, only: [:show, :edit, :update]

  # GET /signatures
  # GET /signatures.json
  #def index
  #  @signatures = Signature.all
  #end

  # GET /signatures/1
  # GET /signatures/1.json def show end

  ## GET /signatures/new
  #def new
  #  puts 'new??'
  #  #@@petition =
  #  @signature = Petition.signatures.new
  #end

  # POST /signatures
  # POST /signatures.json
  def create
    @petition = Petition.find(params[:petition_id])
    @signature = @petition.new_signatures.new(signature_params)

    respond_to do |format|
      if @signature.save
        #puts "saving signature.."
        format.html { redirect_to @petition, notice: 'Signature was successfully created.' }
        format.json { render :show, status: :created, location: @signature }
      else
        format.html { render :new }
        format.json { render json: @signature.errors, status: :unprocessable_entity }
      end
    end
  end

  #def confirm

  #  respond_to do |format|
  #    if @signature.save
  #      format.html { redirect_to @petition, notice: 'Signature was successfully created.' }
  #      format.json { render :show, status: :created, location: @signature }
  #    else
  #      format.html { render :new }
  #      format.json { render json: @signature.errors, status: :unprocessable_entity }
  #    end
  #  end


  #end

  # GET request..
  def confirm
    # If @signature is valid?, but not confirmed yet, confirm it. Record
    # user-agent, remote IP and increase columns signatures_count and
    # last_confirmed_at on the corresponding Petition record.

    #find the petition
    @petition = Petition.find(@signature.petition_id)

    if @signature.valid? && !@signature.confirmed?
      old_signature = @signature
      # create a new one..
      @signature = Signature.new(@signature.as_json)
      @signature.confirmed = true
      @signature.confirmation_remote_addr = request.remote_ip
      @signature.confirmation_remote_browser = request.env['HTTP_USER_AGENT'] unless request.env['HTTP_USER_AGENT'].blank?

      @petition = Petition.find(@signature.petition_id)
      puts @petition.signatures_count
      @petition.signatures_count += 1
      puts @petition.signatures_count
      #Petition.increment_signature_count(@signature.petition_id)
      # delete the old signature
      old_signature.delete
      @signature.save
    end

    respond_to do |format|
      format.html { redirect_to @petition,
                    notice: 'Signature was successfully confirmed.' }
      format.json { render :show, status: :ok, location: @signature }
    end

  end

  # PATCH/PUT /signatures/1
  # PATCH/PUT /signatures/1.json
  def update
    respond_to do |format|
      if @signature.save()
        format.html { redirect_to @petition, notice: 'Signature was successfully updated.' }
        format.json { render :show, status: :ok, location: @signature }
      elsif @signature.update(signature_params)
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
     if not @signature
       @signature = NewSignature.find_by_unique_key(params[:signature_key])
     end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def signature_params
      params.require(:signature).permit(
          :person_city, :person_name, :person_email,
          :subscribe, :visible,
      )
    end
end

class NewSignaturesController < SignaturesController

  def signature_params
      params.require(:new_signature).permit(
          :person_city, :person_name, :person_email,
          :subscribe, :visible,
      )
  end

end
