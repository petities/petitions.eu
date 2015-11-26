class PetitionsController < ApplicationController
  before_action :set_petition, only: [:show, :edit, :update, :finalize, :update_owners]

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

    if @sorting == 'active'
      petitions = petitions.order(active_rate_value: direction)
    elsif @sorting == 'biggest'
      petitions = petitions.order(signatures_count: direction)
    elsif @sorting == 'newest'
      petitions = petitions.order(created_at: direction)
    elsif @sorting == 'sign_quick'
      petitions = petitions.where('date_projected > ?', Time.now).order(date_projected: :asc)
    end

    @sorting_options = [
      { type: 'active', label: t('index.sort.active') },
      { type: 'biggest', label: t('index.sort.biggest') },
      { type: 'newest',      label: t('index.sort.new') },
      { type: 'sign_quick', label: t('index.sort.sign_quick') }
    ]

    @petitions = petitions.paginate(page: @page, per_page: 12)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def all
    @page    = (params[:page] || 1).to_i
    @sorting = params[:sorting] || 'all'
    @order   = params[:order].to_i

    # petitions = Petition.joins(:translations).live
    direction = [:desc, :asc][@order]

    petitions = Petition.live.order(created_at: direction)

    # describe petitions
    if @sorting == 'all'
      petitions = Petition.where("status NOT IN ('draft', 'concept', 'staging')")
    elsif @sorting == 'open'
      petitions = Petition.live
    elsif @sorting == 'concluded'
      petitions = Petition.where(status: 'completed')
    elsif @sorting == 'rejected'
      petitions = Petition.where(status: 'rejected')
    elsif @sorting == 'sign_elsewhere'
      petitions = Petition.where(status: 'not_signable_here')
    end

    @sorting_options = [
      { type: 'all', label: t('all.sort.all') },
      { type: 'open',           label: t('all.sort.open') },
      { type: 'concluded',      label: t('all.sort.concluded') },
      { type: 'rejected',       label: t('all.sort.rejected') },
      { type: 'sign_elsewhere', label: t('all.sort.sign_elsewhere') }
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
    # translation = Petition.findbyname(params[:search])
    petitions = Petition.joins(:translations).
                # with_locales(I18n.available_locales).
                where('petition_translations.name like ?', "%#{@search}%")

    @results_size = petitions.size

    @petitions = petitions.paginate(page: params[:page], per_page: 12)
  end

  def admin
    @page    = (params[:page] || 1).to_i
    @sorting = params[:sorting] || 'live'
    @order   = params[:order].to_i

    # petitions = Petition.joins(:translations).live
    direction = [:desc, :asc][@order]

    petitions = Petition.all.order(created_at: direction)

    # do sorting
    petitions = petitions.where(status: @sorting) if @sorting

    sort_list = []
    # convert all status
    Petition::STATUS_LIST.each do |label, status|
      sort_list.push(type: status, label: label)
    end

    @sorting_options = sort_list

    @petitions = petitions.paginate(page: @page, per_page: 12)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def manage
    if current_user
      # @petitions = current_user.petitions
      @petitions = Petition.with_role(:admin, current_user)
      @results_size = @petitions.size

      @sorting_options = [
        { type: 'all',            label: t('all.sort.all') },
        { type: 'open',           label: t('all.sort.open') },
        { type: 'concluded',      label: t('all.sort.concluded') },
        { type: 'rejected',       label: t('all.sort.rejected') },
        { type: 'sign_elsewhere', label: t('all.sort.sign_elsewhere') }
      ]

      # state new
      #
      # state
    else
      redirect_to new_user_session_path
    end
  end

  # GET /petitions/1
  # GET /petitions/1.json
  def show
    @page = params[:page]

    @owners = find_owners

    if @petition.organisation_id
      @organisation = Organisation.find(@petition.organisation_id)
    end

    @petition_types = PetitionType.all

    set_organisation_helper

    @signature = @petition.signatures.new

    @chart_array = @petition.history_chart_json

    @signatures = @petition.signatures.special.paginate(page: params[:page], per_page: 12)

    @update = Update.new(
      petition_id: @petition.id
    )

    @updates = @petition.updates.paginate(page: 1, per_page: 3)

    if @petition.office_id
      @office = Office.find(@petition.office_id)
    else
      @office = Office.find_by_email('webmaster@petities.nl')
    end

    # TODO.
    # where prominent is TRUE and score is higher then 0
    # ordered by score
    @prominenten = @signatures
  end

  # GET /petitions/new
  def new
    @petition = Petition.new

    @petition_types = PetitionType.all
    set_organisation_helper

  end

  # POST /petitions
  # POST /petitions.json
  def create
    # new_params = Hash(petition_params[:petition])
    @petition = Petition.new(petition_params)
    @petition.status = 'concept'

    @petition.locale_list << I18n.locale

    if petition_params[:organisation_id].present?
      organisation = Organisation.find(petition_params[:organisation_id])

      @petition.organisation_kind = organisation.kind
      @petition.organisation_name = organisation.name
    end

    if params[:images].present?
      params[:images].each do |image|
        @petition.images << Image.new(upload: image)
      end
    end

    if user_signed_in?
      owner = current_user
      @petition.status = 'concept'
    else
      user_params = params[:user]

      if user_params[:email]
        owner = User.where(email: user_params[:email]).first

        unless owner
          owner = User.create(
            email: user_params[:email],
            username: user_params[:name],
            password: user_params[:password]
          )
        end
      end
    end

    respond_to do |format|
      if @petition.save
        owner.add_role :admin, @petition if owner

        format.html { redirect_to @petition, flash: { success: t('petition.created') } }
        format.json { render :show, status: :created, location: @petition }
      else
        format.html { render :new }
        format.json { render json: @petition.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /petitions/1/edit
  def edit
    authorize @petition

    @owners = find_owners
    @petition_types = PetitionType.all

    set_organisation_helper

    @signatures = @petition.signatures.special.paginate(page: params[:page], per_page: 12)
    
    if @petition.status.nil?
      @petition.status = 'draft'
    end

    @petition_flash = t('petition.status.flash.%s' % @petition.status, default: @petition.status)

    @images = @petition.images

    @update = Update.new(
      petition_id: @petition.id
    )

    @updates = @petition.updates.paginate(page: 1, per_page: 3)

  end


  def makeI18noption o_t
    value = o_t[0]
    visible_value = t('petition.organisations.%s' % o_t[0], default: o_t[0]) 

    return [visible_value, value]
  end

  def set_organisation_helper
    @organisation_types = Organisation.all.where(visible: true).sort_by(&:name).group_by(&:kind)
    #@organisation_type_options = @organisation_types.map{|o_t| makeI18noption(o_t) }

    @organisation_type_prepared = {}
    @organisation_types.each  do |type, collection|
      i18n_col = collection.map{|org| [t('petition.organisations.%s' % org.name, default: org.name), org.id]}
      @organisation_type_prepared[type] = i18n_col
    end
    
    @publicbodies_sort_order = [
      [t('petition.organisations.%s' %  'counsil') , 'counsil'],
      [t('petition.organisations.%s' %  'plusregion'), 'plusregion'],
      [t('petition.organisations.%s' %  'water_county'), 'water_county'],
      [t('petition.organisations.%s' %  'district'), 'district'],
      [t('petition.organisations.%s' %  'governement'), 'governement'],
      [t('petition.organisations.%s' %  'parliament'), 'parliament'],
      [t('petition.organisations.%s' %  'european_union'), 'european_union'],
      [t('petition.organisations.%s' %  'collective') , 'collective']
    ]
    
  end

  #
  def update_owners
    authorize @petition
    @owners = find_owners

    owner_ids = [*params[:owner_ids]].map(&:to_i)
    owner_ids.uniq!

    # remove ownership for users not in owners_ids

    unless owner_ids.empty?

      diff1 = @owners.ids - owner_ids

      diff1.each do |id|
        user = User.find(id)
        user.remove_role(:admin, @petition)
      end
    end

    # add a user to role
    if params[:add_owner]
      user = User.find_by_email(params['add_owner'])
      user.add_role :admin, @petition if user
    end

    respond_to do |format|
      format.html { render :edit }
      format.json { render :show, status: :ok, location: @petition }
    end
  end

  # PATCH/PUT /petitions/1
  # PATCH/PUT /petitions/1.json
  def update
    authorize @petition

    @owners = find_owners

    locale = params[:add_locale] || I18n.locale
    update_locale_list(locale.to_sym) if params[:add_locale]

    # if petition_params[:organisation_id].present?
    #   organisation = Organisation.find(petition_params[:organisation_id])
    #   @petition.organisation_kind, @petition.organisation_name = organisation.kind, organisation.name
    # end

    if params[:images].present?
      params[:images].each do |image|
        @petition.images << Image.new(upload: image)
      end
    end

    Globalize.with_locale(locale) do
      respond_to do |format|
        if @petition.update_attributes(petition_params)
          format.html { redirect_to edit_petition_path(@petition), flash: { success: 'Petition was successfully updated.' } }
          format.json { render :show, status: :ok, location: @petition }
        else
          format.html { render :edit }
          format.json { render json: @petition.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def finalize
    authorize @petition

    PetitionMailer.finalize_mail(@petition).deliver_later

    flash[:notice] = 'Your petition is awaiting moderation. If you are in a hurry, please leave a voicemail at +31207854412'
    redirect_to edit_petition_path(@petition)
  end

  # DELETE /petitions/1
  # DELETE /petitions/1.json
  # def destroy
  #  @petition.destroy
  #  respond_to do |format|
  #    format.html { redirect_to petitions_url, notice: 'Petition was successfully destroyed.' }
  #    format.json { head :no_content }
  #  end
  # end

  private

  # Use callbacks to share common setup or constraints between actions.
  #
  def set_petition
    Globalize.locale = params[:locale] || I18n.locale

    # find petition by slug name subdomain, id, friendly_name
    if params[:slug]
      @petition = Petition.find_by_cached_slug(params[:slug])
    elsif params[:subdomain]
      @petition = Petition.find_by_subdomain(params[:subdomain])
    elsif params[:petition_id]
      @petition = Petition.find(params[:petition_id])
    else
      begin
        # find by friendly url
        @petition = Petition.friendly.find(params[:id])
      rescue
        # find in all locales petition that matches..
        @petition = Petition.joins(:translations)
                    .where('petition_translations.slug like ?', "%#{params[:id]}%").first
      end
    end

    # find specific papertrail version
    @version_index = 0

    @version_index = @petition.index if @petition.has_attribute? :index

    if params[:version].to_i < 0
      @version_index = params[:version].to_i
      @petition = @petition.versions[@version_index].reify
    end

    @up = @version_index < 0 ? @version_index + 1 : 0
    @down = @version_index.abs < @petition.versions.size ? @version_index - 1 : @version_index
  end

  def find_owners
    User.joins(:roles).where(
      roles: { resource_type: 'Petition', resource_id: @petition.id })
  end

  def update_locale_list(_locale)
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
      :name, :description, :statement, :request, :initiators, :status,
      :organisation_id, :organisation_kind, :petitioner_email, :petitioner_name, :password,
      :petition_type_id
    )
    #:subscribe, :visible,
  end
end
