class PetitionsController < ApplicationController
  include FindPetition
  include SortPetitions

  before_action :set_petition, only: [:show, :edit, :update, :finalize, :update_owners]
  before_action only: [:show, :edit]

  # GET /petitions
  # GET /petitions.json
  def index
    @vervolg = true

    @page    = (params[:page] || 1).to_i
    @sorting = params[:sorting] || 'active'
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
    elsif @sorting == 'signquick'
      petitions = petitions.where('date_projected > ?', Time.now).order(date_projected: :asc)
    end

    @sorting_options = [
      { type: 'active', label: t('index.sort.active') },
      { type: 'newest', label: t('index.sort.new') },
      #{ type: 'biggest', label: t('index.sort.biggest') },
      { type: 'signquick', label: t('index.sort.sign_quick') }
    ]

    @petitions = petitions.paginate(page: @page, per_page: 12)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def all
    @petitions = sort_petitions Petition

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
    petitions = Petition.joins(:translations)
                .where('petition_translations.name like ?', "%#{@search}%")
                .distinct
                # with_locales(I18n.available_locales).


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
      # TODO we should convert managers to admin..
      @petitions = Petition.with_role(:admin, current_user)

      @results_size = @petitions.size

      petitions_by_status @petitions

    else
      redirect_to new_user_session_path
    end
  end

  def set_petition_vars
    @page = params[:page] || 1

    if @petition.organisation_id
      @organisation = Organisation.find(@petition.organisation_id)
    end

    @chart_data, @chart_labels = @petition.history_chart_json

    @updates = @petition.updates.paginate(page: @page, per_page: 3)
  end

  # GET /petitions/1
  # GET /petitions/1.json
  def show

    unless @petition
      flash[:notice] = t('petition.we_could_not_find_petition_try_search')
      redirect_to root_path
      return
    end

    @owners = @petition.find_owners

    set_petition_vars

    set_organisation_helper

    @signature = @petition.signatures.new

    @images = @petition.images

    @signatures = @petition.signatures
                  .special
                  .reverse_order
                  .paginate(page: params[:page], per_page: 12)

    if @petition.office_id
      @office = Office.find(@petition.office_id)
    else
      @office = Office.find_by_email('nederland@petities.nl')
    end

    @answer = @petition.updates.where(show_on_petition: true).first

    # TODO.
    # where prominent is TRUE and score is higher then 0
    # ordered by score
    @prominenten = @signatures
  end

  # GET /petitions/new
  def new
    @petition = Petition.new

    @exclude_list = [] 

    set_organisation_helper

    if user_signed_in?
      owner = current_user
      # copy user info
      @petition.petitioner_name = owner.username
      @petition.petitioner_address = owner.address
      @petition.petitioner_postalcode = owner.postalcode
      @petition.petitioner_telephone = owner.telephone
      @petition.petitioner_email = owner.email
      @petition.petitioner_city = owner.city
    end
  end

  # POST /petitions
  # POST /petitions.json
  def create
    # new_params = Hash(petition_params[:petition])
    @petition = Petition.new(petition_params)

    @petition.status = 'concept'

    @petition.locale_list << I18n.locale

    set_petition_vars

    set_office

    set_organisation_helper

    if params[:images].present?
      params[:images].each do |image|
        @petition.images << Image.new(upload: image)
      end
    end

    @password = 'you already have'

    if user_signed_in?
      owner = current_user
      # send welcome mail anyways..
    else
      user_params = params[:user]

      if user_params[:email]
        owner = User.where(email: user_params[:email]).first

        unless owner

          password = user_params[:password]
          password = Devise.friendly_token.first(8) if password.blank?

          owner = User.new(
            email: user_params[:email],
            username: user_params[:email],
            name: user_params[:name],
            password: password
          )
          owner.send(:generate_confirmation_token)
          owner.skip_confirmation!
          owner.skip_confirmation_notification!
          owner.confirmed_at = nil
          owner.save
          @password = password
          # send welcome / password if needed
        end
      end
    end

    respond_to do |format|
      # petition is save. status change causes email(s)
      # to be send
      if @petition.save
        # make user owner of the petition
        owner.add_role(:admin, @petition) if owner
        PetitionMailer.welcome_petitioner_mail(@petition, owner, password).deliver_later
        PetitionMailer.welcome_petitioner_mail(
          @petition, owner, password, target: 'webmaster@petities.nl').deliver_later

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

    @exclude_list = policy(@petition).invalid_attributes

    @page = params[:page]

    @owners = @petition.find_owners

    set_petition_vars

    set_organisation_helper

    @signatures = @petition.signatures.special.paginate(page: params[:page], per_page: 12)

    @petition.status = 'draft' if @petition.status.nil?

    @petition_flash = t('petition.status.flash.%s' % @petition.status, default: @petition.status)

    @images = @petition.images
  end

  def set_organisation_helper
    @petition_types = PetitionType.all

    @organisation_types = Organisation.visible.sort_by(&:name).group_by(&:kind)

    @organisation_type_prepared = {}
    @organisation_types.each  do |type, collection|
      i18n_col = collection.map { |org| [t('petition.organisations.%s' % org.name, default: org.name), org.id] }
      @organisation_type_prepared[type] = i18n_col
    end

    @publicbodies_sort_order = [
      [t('petition.organisations.%s' % 'counsil'), 'counsil'],
      [t('petition.organisations.%s' % 'plusregion'), 'plusregion'],
      [t('petition.organisations.%s' % 'water_county'), 'water_county'],
      [t('petition.organisations.%s' % 'district'), 'district'],
      [t('petition.organisations.%s' % 'governement'), 'governement'],
      [t('petition.organisations.%s' % 'parliament'), 'parliament'],
      [t('petition.organisations.%s' % 'european_union'), 'european_union'],
      [t('petition.organisations.%s' % 'collective'), 'collective']
    ]
  end

  #
  def update_owners
    authorize @petition

    @owners = @petition.find_owners

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

  def set_office
    if petition_params[:organisation_id].present?
      organisation = Organisation.find(petition_params[:organisation_id])
      @petition.organisation_kind = organisation.kind
      @petition.organisation_name = organisation.name

      office = Office.find_by_organisation_id(organisation.id)
      if office && !office.hidden?
        @petition.office = office
      else
        @petition.office = Office.find_by_email('nederland@petities.nl')
      end
    end
  end

  # PATCH/PUT /petitions/1
  # PATCH/PUT /petitions/1.json
  def update
    authorize @petition

    @owners = @petition.find_owners

    set_petition_vars

    set_office

    set_organisation_helper

    update_locale_list

    if params[:images].present?
      params[:images].each do |image|
        @petition.images << Image.new(upload: image)
      end
    end

    # update params_with permissions
    # only update what is allowed
    exclude_list = policy(@petition).invalid_attributes
    filtered_params = petition_params.except(*exclude_list)

    #crashh_please

    Globalize.with_locale(locale) do
      respond_to do |format|
        if @petition.update(filtered_params)
          format.html { redirect_to edit_petition_path(@petition), flash: { success: 'Petition was successfully updated.' } }
          format.json { render :show, status: :ok, location: @petition }
        else
          @petition_flash = t('petition.errors.look_at_form')
          format.html { render :edit }
          format.json { render json: @petition.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # send petition to moderation
  def finalize
    authorize @petition

    @petition.update(status: 'staging')
    flash[:notice] = t('petition.status.flash.your_petition_awaiting_moderation')

    if @petition.office.present?
      if user_signed_in?
        if current_user.has_role?(:admin, @petition.office)
          @petition.update(status: 'live')
          flash[:notice] = t('petition.status.flash.your_petition_is_live')
        end
      end
      PetitionMailer.finalize_mail(@petition).deliver_later
      PetitionMailer.finalize_mail(@petition, target: 'nederland@petities.nl').deliver_later
    end
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

  def set_petition
    find_petition

    if @petition.nil?
      return
    end

    @update = @petition.updates.new

    # find specific papertrail version
    @version_index = 0

    @version_index = @petition.index if @petition.has_attribute? :index

    if params[:version].to_i < 0
      @version_index = params[:version].to_i
      @petition = @petition.versions[@version_index].reify
    end

    @up = @version_index < 0 ? @version_index + 1 : 0
    @down = @version_index.abs < @petition.versions.size ? @version_index - 1 : @version_index

    # If an old id or a numeric id was used to find the record, then
    # the request path will not match the post_path, and we should do
    # a 301 redirect that uses the current friendly id.
    if params[:action] == :show
      if request.path != petition_path(@petition).split('?')[0]
        return redirect_to @petition, status: :moved_permanently
      end
    end
  end

  def update_locale_list
    locale = params[:locale] || I18n.locale
    # update the locale menu here
    @petition.locale_list << locale.to_sym
    @petition.locale_list.uniq!
  end

  # TODO: Refactor update form to use RJS and remove this
  # WELL THIS CRASHES :)
  #def initialize_update
  #  @update = @petition.updates.new
  #end

  # Never trust parameters from the scary internet, only allow the white list through.
  def petition_params
    params.require(:petition).permit(
      :name, :description, :statement, :request, :initiators, :status,
      :organisation_id, :organisation_kind,
      :petitioner_email,
      :petitioner_telephone,
      :petitioner_name,
      :petitioner_organisation,
      :petitioner_telephone,
      :petition_type_id,
      :date_projected,
      :answer_due_date,
      :reference_field,
      :link1, :link1_text,
      :link2, :link2_text,
      :link3, :link3_text,
      :subdomain
    )
    #:subscribe, :visible,
  end

  # add remove locales
  def locale_params
    params.require(:petition).permit(
      :add_locale,
      :remove_locale
    )
  end

  # add remove owners
  def owner_params
    params.require(:petition).permit(
      :user_email,
      :user_id
    )
  end
end
