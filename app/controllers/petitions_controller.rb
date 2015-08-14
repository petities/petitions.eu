class PetitionsController < ApplicationController
  before_action :set_petition, only: [:show, :edit, :add_translation, :update, :update_owners]

  # GET /petitions
  # GET /petitions.json
  def index
    @vervolg = true

    @page    = (params[:page] || 1).to_i
    @sorting = params[:sort] || 'active'
    @order = params[:order].to_i

    # petitions = Petition.joins(:translations).live
    petitions = Petition.live
    direction = [:desc, :asc][@order]
    
    if @sorting == 'active' then
      petitions = petitions.order(active_rate_value: direction)
    elsif @sorting == 'biggest'
      petitions = petitions.order(signatures_count: direction)
    elsif @sorting == 'newest'
      petitions = petitions.order(created_at: direction)
    elsif @sorting == 'sign_quick'
      petitions = petitions.where('date_projected > ?', Time.now).order(date_projected: :asc)
    end

    @sorting_options = [
      {type: 'active',      label: t('index.sort.active')}, 
      {type: 'biggest',     label: t('index.sort.biggest')},
      {type: 'newest',      label: t('index.sort.new')},
      {type: 'sign_quick',  label: t('index.sort.sign_quick')}
    ]

    @petitions = petitions.paginate(page: @page, per_page: 12)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def all
    @page    = (params[:page] || 1).to_i
    @sorting = params[:status] || 'all'
    @order   = params[:order].to_i

    # petitions = Petition.joins(:translations).live
    direction = [:desc, :asc][@order]

    petitions = Petition.live.order(created_at: direction)
    
    if @sorting == 'all' then
      petitions = petitions.where("status NOT IN ('draft', 'concept', 'staging')")
    elsif @sorting == 'open'
      # petitions = petitions.order(signatures_count: direction)
    elsif @sorting == 'concluded'
      petitions = petitions.where(status: 'completed')
    elsif @sorting == 'sign_elsewhere'
      petitions = petitions.where(status: 'not_signable_here')
    end

    @sorting_options = [
      {type: 'all',            label: t('all.sort.all')}, 
      {type: 'open',           label: t('all.sort.open')},
      {type: 'concluded',      label: t('all.sort.concluded')},
      {type: 'rejected',       label: t('all.sort.rejected')},
      {type: 'sign_elsewhere', label: t('all.sort.sign_elsewhere')}
    ]

    @results_size = petitions.size

    @petitions = petitions.paginate(page: @page, per_page: 12)

    respond_to do |format|
      format.html
      format.js
    end
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

  def manage
    if current_user
      @petitions = current_user.petitions
      @results_size = @petitions.size
    else
      redirect_to new_user_session_path 
    end
  end

  # GET /petitions/1
  # GET /petitions/1.json
  def show
    @page = params[:page]

    @owners = find_owners

    @signature = @petition.signatures.new

    @chart_array = @petition.history_chart_json

    @signatures = @petition.signatures.special.paginate(page: params[:page], per_page: 12)

    @updates = @petition.updates.paginate(page: 1, per_page: 3)
    
    # TODO.
    # where prominent is TRUE and score is higher then 0
    # ordered by score
    @prominenten = @signatures
  end

  # GET /petitions/new
  def new
    @petition = Petition.new

    @petition_types = PetitionType.all
    @organisation_types = Organisation.all.sort_by{|o| o.name}.group_by{|o| o.kind}
  end

  # POST /petitions
  # POST /petitions.json
  def create
    # new_params = Hash(petition_params[:petition])
    @petition = Petition.new(petition_params)

    @petition.locale_list << I18n.locale

    if petition_params[:organisation_id].present?
      organisation = Organisation.find(petition_params[:organisation_id])
      
      @petition.organisation_kind, @petition.organisation_name = organisation.kind, organisation.name
    end
    
    if params[:images].present?
      params[:images].each do |image|
        @petition.images << Image.new(upload: image)
      end
    end

    if !user_signed_in?
      user_params = params[:user]

      if user_params[:email]
        user = User.where(email: user_params[:email]).first

        unless user
          User.create(
            email: user_params[:email], 
            username: user_params[:name], 
            password: user_params[:password]
          )
        end
      end
    end

    respond_to do |format|
      if @petition.save
        format.html { redirect_to @petition, flash: { success: t('petition.created') }}
        format.json { render :show, status: :created, location: @petition }
      else
        format.html { render :new }
        format.json { render json: @petition.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /petitions/1/edit
  def edit
    # authorize @petition
    @owners = find_owners

    @petition_types = PetitionType.all
    @organisation_types = Organisation.all.sort_by{|o| o.name}.group_by{|o| o.kind}
  end

  def add_translation
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

    locale = params[:add_locale] || I18n.locale
    update_locale_list(locale.to_sym) if params[:add_locale]

    # if petition_params[:organisation_id].present?
    #   organisation = Organisation.find(petition_params[:organisation_id])
      
    #   @petition.organisation_kind, @petition.organisation_name = organisation.kind, organisation.name
    # end

    if params[:commit] == 'Finalize'
      PetitionMailer.finalize_mail(@petition).deliver
    end

    Globalize.with_locale(locale) do
      respond_to do |format|
        if @petition.update_attributes(petition_params)
          format.html { redirect_to edit_petition_path(@petition), flash: { success: 'Petition was successfully updated.'}}
          format.json { render :show, status: :ok, location: @petition }
        else
          format.html { render :edit }
          format.json { render json: @petition.errors, status: :unprocessable_entity }
        end
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
      Globalize.locale = params[:locale] || I18n.locale
    
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

    def update_locale_list(locale)
      # update the locale menu here
      @petition.locale_list << params[:add_locale].to_sym
      @petition.locale_list.uniq!
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def petition_params
      # :add_locale, :version, :owner_ids, :add_owner, 
      # petition: [
      # locale_list: []
      params.require(:petition).permit(
        :name, :description, :statement, :request, :initiators,
        :organisation_id, :organisation_kind, :petitioner_email, :petitioner_name, :password,
        :petition_type_id
      )
      #:subscribe, :visible,
    end
end
