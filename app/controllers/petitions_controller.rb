class PetitionsController < ApplicationController
  before_action :set_petition, only: [:show, :edit, :update, :destroy]

  # GET /petitions
  # GET /petitions.json
  def index
    @page = params[:page]
    order = params[:order] || 0
    @sorting = params[:sort]

    petitions = Petition

    # enable search on petition title. TODO ransack?
    @search = 0
    if params[:search]
      petitions = Petition.findbyname(params[:search])
      @search = params[:search]
    end

    # enable sorting..
    if @sorting then
        direction = [:desc, :asc][order.to_i]
        if @sorting == 'name' then
          petitions = petitions.order(name: direction)
        else
          petitions = petitions.order(signatures_count: direction)
        end
    end

    @petitions = petitions.paginate(:page => params[:page])
    @order = order == '1'? 0 : 1

  end

  # GET /petitions/1
  # GET /petitions/1.json
  def show
    @signature = @petition.signatures.new

    @signatures = @petition.signatures
    @signatures = @signatures.order(created_at: :desc)
    @signatures = @signatures.paginate(:page => params[:page])

    @prominenten = @signatures
  end

  # GET /petitions/new
  def new
    @petition = Petition.new
  end

  # GET /petitions/1/edit
  def edit
  end

  # POST /petitions
  # POST /petitions.json
  def create
    @petition = Petition.new(petition_params)

    respond_to do |format|
      if @petition.save
        format.html { redirect_to @petition, :flash => {
            :success => t('petition.created')} }
        format.json {
            render :show, status: :created, location: @petition }
      else
        format.html { render :new }
        format.json {
            render json: @petition.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /petitions/1
  # PATCH/PUT /petitions/1.json
  def update

    #@authorize @petition

    new_params = Hash(petition_params[:petition])

    if params[:add_locale]
      # add a locale
      @petition.locale_list << params[:add_locale]
      @petition.locale_list.uniq!
    elsif new_params.empty?
      # NOTE we can not check for locale_list, when checklist is empty 
      # the browser sends nothing
      # now update locale list from selection menu
      locale_list = [*petition_params[:locale_list]]
      locale_list.uniq!
      @petition.locale_list = locale_list
      # remove the locale list otherwise @petition.update fails
      new_params.delete(:locale_list)
    end

    respond_to do |format|
      if @petition.update(new_params)
        #format.html { redirect_to @petition, :flash => {
        format.html { render :edit, :flash => {
            :success => 'Petition was successfully updated.',
            :error => locale_list }
        }
        format.json { render :show, status: :ok, location: @petition }
      else
        format.html { render :edit }
        format.json { render json: @petition.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /petitions/1
  # DELETE /petitions/1.json
  #def destroy
  #  @petition.destroy
  #  respond_to do |format|
  #    format.html { redirect_to petitions_url, notice: 'Petition was successfully destroyed.' }
  #    format.json { head :no_content }
  #  end
  #end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_petition
      # find petition by slug name subdomain or id.
      if params[:slug]
        @petition = Petition.find_by_cached_slug(params[:slug])
      elsif params[:subdomain]
        @petition = Petition.find_by_subdomain(params[:subdomain])
      else 
        @petition = Petition.find(params[:id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def petition_params
      params.permit(:add_locale, petition: [
        :name, :description, :request, :petitioner_email, :password,
        :statement, :initiators, :petition_id, 
        locale_list: []])
        #:subscribe, :visible,
    end
end
