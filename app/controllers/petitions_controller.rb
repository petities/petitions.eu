class PetitionsController < ApplicationController
  before_action :set_petition, only: [:show, :edit, :update, :update_owners]

  # GET /petitions
  # GET /petitions.json
  def index
    @page    = params[:page].to_i || 1
    @sorting = params[:sort] || 'active'
    order = params[:order] || 0

    petitions = Petition.joins(:translations).live
    direction = [:desc, :asc][order.to_i]
    
    if @sorting == 'active' then
      petitions = petitions.order(name: direction)
    elsif @sorting == 'name'
      petitions = petitions.order(signatures_count: direction)
    end
    
    @petitions = petitions.paginate(page: params[:page], per_page: 24)
  end

  def search
    # enable search on petition title. TODO ransack?
    # @search = 0
    @page = params[:page] || 1

    @search = params[:search]
    #translation = Petition.findbyname(params[:search])
    petitions = Petition.joins(:translations).
      #with_locales(I18n.available_locales). 
      where("petition_translations.name like ?", "%#{@search}%")

    @results_size = petitions.size

    @petitions = petitions.paginate(page: params[:page], per_page: 12)
  end

  # GET /petitions/1
  # GET /petitions/1.json
  def show
    @page = params[:page]

    @owners = find_owners

    @signature = @petition.signatures.new

    @signatures = @petition.signatures
    @chart_array = @signatures.map{|signature| signature.confirmed_at }.compact
                              .group_by{|signature| signature.strftime("%Y-%m-%d")}
                              .map{|group| {y: group[1].size}}.to_json.html_safe

    @signatures = @signatures.order(created_at: :desc).paginate(page: params[:page], per_page: 12)
    
    # TODO.
    # where prominent is TRUE and score is higher then 0
    # ordered by score
    @prominenten = @signatures
  end

  # GET /petitions/new
  def new
    @petition = Petition.new
  end

  # GET /petitions/1/edit
  def edit
    authorize @petition
    @owners = find_owners
  end

  # POST /petitions
  # POST /petitions.json
  def create

    new_params = Hash(petition_params[:petition])
    @petition = Petition.new(new_params)

    if params[:images].present?
      params[:images].each do |image|
        @petition.images << Image.new(upload: image)
      end
    end

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

  def update_locale_list(params, new_params)
    # update the locale menu here
    if params[:add_locale]
      # add a single locale from the side bar like "klingon"
      @petition.locale_list << params[:add_locale]
      @petition.locale_list.uniq!
    elsif new_params.empty?
      # set the locale list from the side bar ["en", "de", "lim"]
      # NOTE we can not check for locale_list, when checklist is empty 
      # the browser sends nothing
      # on no locale list and no petition parameter. locale_list = []
      # now update locale list from selection menu
      locale_list = [*petition_params[:locale_list]]
      locale_list.uniq!
      @petition.locale_list = locale_list
      # remove the locale list otherwise @petition.update fails
      new_params.delete(:locale_list)
    end

    new_params
  end

  # POST /petitions/1
  def update_owners
    authorize @petition
    @owners = find_owners

    owner_ids = [*params[:owner_ids]].map(&:to_i)
    owner_ids.uniq!

    # remove ownership for users not in owners_ids

    if not owner_ids.empty?

      diff1 = @owners.ids - owner_ids

      diff1.each do |id|
        user = User.find(id)
        user.remove_role(:admin, @petition)
      end
    end

    # add a user to role
    if params[:add_owner]
      user = User.find_by_email(params["add_owner"])
      if user
        user.add_role :admin, @petition 
      end
    end

    respond_to do |format|
      format.html { render :edit }
      format.json { render :show, status: :ok, location: @petition }
    end

  end

  # PATCH/PUT /petitions/1
  # PATCH/PUT /petitions/1.json
  def update

    @owners = find_owners

    new_params = Hash(petition_params[:petition])

    new_params = update_locale_list(params, new_params)

    respond_to do |format|
      if @petition.update(new_params)
        #format.html { redirect_to @petition, :flash => {
        format.html { render :edit, :flash => {
            :success => 'Petition was successfully updated.'}
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
  #
    def set_petition
      # find petition by slug name subdomain or id.
      if params[:slug]
        @petition = Petition.find_by_cached_slug(params[:slug])
      elsif params[:subdomain]
        @petition = Petition.find_by_subdomain(params[:subdomain])
      elsif params[:petition_id]
        @petition = Petition.find(params[:petition_id])
      else 
        @petition = Petition.find(params[:id])
      end

      # find specific papertrail version
      @index = 0

      if params[:version]
        @index = params[:version].to_i
        @petition = @petition.versions[@index].reify
      end

      if @petition.has_attribute? :index
        @index = @petition.index
      end

      @up = @index < 0 ? @index + 1 : 0 
      @down = @index.abs < @petition.versions.size ? @index-1 : @index

    end

    def find_owners
      User.joins(:roles).where(
        roles: {resource_type: 'Petition', resource_id: @petition.id})
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def petition_params
      params.permit(:add_locale, :version, :owner_ids, :add_owner, 
        petition: [
          :name, :description, :request, :organisation_name, :petitioner_email, :petitioner_name, :password,
          :statement, :initiators, :petition_id, locale_list: []
        ]
      )
        #:subscribe, :visible,
    end
end
