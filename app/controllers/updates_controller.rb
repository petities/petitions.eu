class UpdatesController < ApplicationController
  
  before_action :set_newsitem, only: [:show]

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

  def show
     @page = (params[:page] || 1).to_i

      @updates = Update.all

      per_page = request.xhr? ? 3 : 8

      @updates = @updates.paginate(page: @page, per_page: per_page)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    #
    def set_newsitem
      # find by friendly url
      @selected_update = Update.friendly.find(params[:id])
    end


end