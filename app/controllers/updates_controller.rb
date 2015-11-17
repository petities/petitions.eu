class UpdatesController < ApplicationController
  
  before_action :set_newsitem, only: [:show, :edit, :update]

  def index
    @page = (params[:page] || 1).to_i

    @updates = Update.all

    per_page = request.xhr? ? 3 : 8

    @updates = @updates.paginate(page: @page, per_page: per_page)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def new

    #@offices = Office.where(hidden: false)
    @offices = Office.all
    @petitions = Petition.live
    @update = Update.new
    #authorize @update
  end

  def show
     @page = (params[:page] || 1).to_i

     @updates = Update.all

     per_page = request.xhr? ? 3 : 8

     @updates = @updates.paginate(page: @page, per_page: per_page)
  end

  def create
    @update = Update.new(update_params)
    authorize @update

    respond_to do |format|
      if @update.save
        format.html { redirect_to @update, flash: { success: t('update.created') }}
        format.json { render :show, status: :created, location: @update }
      else
        format.html { render :new }
        format.json { render json: @update.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    authorize @update
  end

  def update
    authorize @update

    respond_to do |format|
      if @update.update_attributes(update_params)
        format.html { redirect_to @update, flash: { success: t('update.updated') }}
        format.json { render :show, status: :created, location: @update }
      else
        format.html { render :edit }
        format.json { render json: @update.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    #
    def set_newsitem
      # find by friendly url
      @update = Update.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def update_params
      # :add_locale, :version, :owner_ids, :add_owner,
      # petition: [
      # locale_list: []
      params.require(:update).permit(
        :title, :text, :show_on_home, :show_on_office,
        :petition_id, :office_id,
      )
    end


end
