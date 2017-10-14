class PetitionsController < ApplicationController
  include FindPetition
  include SortPetitions

  before_action :set_petition, only: [:show, :edit, :update, :finalize]

  # GET /petitions
  # GET /petitions.json
  def index
    @page    = cleanup_page(params[:page])
    @sorting = params[:sorting] || 'active'
    @order = params[:order].to_i

    petitions = Petition.live

    petitions = case @sorting
                when 'active'
                  Petition.active_from_redis
                when 'biggest'
                  Petition.biggest_from_redis
                when 'newest'
                  direction = [:desc, :asc][@order]
                  petitions.order(created_at: direction)
                when 'signquick'
                  petitions.where('date_projected > ?', Time.now).order(date_projected: :asc)
                else
                  petitions
                end

    @sorting_options = ['active', 'newest', 'biggest', 'signquick']

    @petitions = petitions.page(@page).per(12)

    respond_to :html, :js
  end

  def all
    @petitions = sort_petitions(Petition)

    respond_to :html, :js
  end

  def search
    page = cleanup_page(params[:page])

    @search = params[:search]
    petitions = Petition.live.joins(:translations)
                        .where('petition_translations.name like ?', "%#{@search}%")
                        .distinct
                        .sort_by { |p| -($redis.zscore('active_rate', p.id) || 0) }

    @petitions = Kaminari.paginate_array(petitions).page(page).per(12)
  end

  def manage
    if current_user
      @petitions = Petition.with_role(:admin, current_user)

      petitions_by_status @petitions
    else
      redirect_to new_user_session_path
    end
  end

  def set_petition_vars
    @page = cleanup_page(params[:page])

    @chart_data, @chart_labels = @petition.redis_history_chart_json(20)

    @updates = @petition.updates.page(@page).per(3)
  end

  # GET /petitions/1
  # GET /petitions/1.json
  def show
    set_petition_vars

    @signature = @petition.signatures.new

    @signatures = @petition.signatures.ordered.limit(12)

    @office = @petition.office

    @answer = @petition.answer

    respond_to :html, :json
  end

  # GET /petitions/new
  def new
    @petition = Petition.new

    @exclude_list = []

    set_organisation_helper
  end

  # POST /petitions
  # POST /petitions.json
  def create
    @petition = Petition.new(petition_params)

    @petition.status = 'concept'

    set_petition_vars

    set_office

    set_organisation_helper

    @exclude_list = []


    if user_signed_in?
      owner = current_user
      # send welcome mail anyways..
    else
      user_params = params[:user]

      if user_params[:email].present?
        owner = User.where(email: user_params[:email]).first

        unless owner
          password = Devise.friendly_token.first(8)

          owner = User.new(
            email: user_params[:email],
            name: user_params[:name],
            password: password
          )
          owner.send(:generate_confirmation_token)
          owner.skip_confirmation!
          owner.skip_confirmation_notification!
          owner.confirmed_at = nil
          owner.save
          # send welcome / password if needed
        end

        @petition.petitioner_name = owner.name
        @petition.petitioner_email = owner.email
      else
        @missing_email = t('petition.missing_email')

        respond_to do |format|
          format.html { render :new, flash: { success: t('petition.missing_email') } }
          format.json { render json: @petition.errors, status: :unprocessable_entity }
        end

        return
      end
    end

    respond_to do |format|
      # petition is save. status change causes email(s) to be send
      if @petition.save
        if owner && owner.persisted?
          # make user owner of the petition
          owner.add_role(:admin, @petition)
          PetitionMailer.welcome_petitioner_mail(@petition, owner, password).deliver_later
        end

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

    @page = cleanup_page(params[:page])

    set_petition_vars

    set_organisation_helper

    @signatures = @petition.signatures.ordered.page(@page).per(12)
  end

  def set_organisation_helper
    @petition_types = PetitionType.all

    organisation_types = Organisation.visible.order(:name).group_by(&:kind)

    @organisation_type_prepared = {}
    organisation_types.each do |type, collection|
      i18n_col = collection.map do |org|
        [t("petition.organisations.#{org.name}", default: org.name), org.id]
      end
      @organisation_type_prepared[type] = i18n_col
    end

    @publicbodies_sort_order = [
      [t('petition.organisations.counsil'), 'counsil'],
      [t('petition.organisations.plusregion'), 'plusregion'],
      [t('petition.organisations.water_county'), 'water_county'],
      [t('petition.organisations.district'), 'district'],
      [t('petition.organisations.government'), 'government'],
      [t('petition.organisations.parliament'), 'parliament'],
      [t('petition.organisations.european_union'), 'european_union'],
      [t('petition.organisations.collective'), 'collective']
    ]
  end

  def set_office
    if petition_params[:organisation_id].present?
      organisation = Organisation.find(petition_params[:organisation_id])
      @petition.organisation_kind = organisation.kind
      @petition.organisation_name = organisation.name

      office = Office.visible.find_by(organisation_id: organisation.id)
      @petition.office = office if office
    end
  end

  # PATCH/PUT /petitions/1
  # PATCH/PUT /petitions/1.json
  def update
    authorize @petition

    @exclude_list = policy(@petition).invalid_attributes

    set_petition_vars

    set_office

    set_organisation_helper

    # update params_with permissions only update what is allowed
    filtered_params = petition_params.except(@exclude_list)

    Globalize.with_locale(locale) do
      respond_to do |format|
        if @petition.update(filtered_params)
          format.html { redirect_to edit_petition_path(@petition), flash: { success: t('petition.update.success') } }
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

    if current_user.has_role?(:admin, @petition)
      @petition.update(status: 'staging')
      flash[:notice] = t('petition.status.flash.your_petition_awaiting_moderation')
      PetitionMailer.finalize_mail(@petition).deliver_later
    end

    if @petition.office.present? && current_user.has_role?(:admin, @petition.office)
      @petition.update(status: 'live')
      flash[:notice] = t('petition.status.flash.petition_is_live')
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

    return if @petition.nil?

    @update = Update.new(petition_id: @petition.id)

    # find specific papertrail version
    if params[:version].to_i > 0
      versioned_petition = @petition.versions[params[:version].to_i]
      @petition = versioned_petition.reify if versioned_petition
    end

    # If an old id or a numeric id was used to find the record, then
    # the request path will not match the post_path, and we should do
    # a 301 redirect that uses the current friendly id.
    if params[:action] == :show
      if request.path != petition_path(@petition).split('?')[0]
        return redirect_to @petition, status: :moved_permanently
      end
    end
  end

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
      :subdomain,
      images_attributes: [:id, :upload, :_destroy]
    )
  end
end
