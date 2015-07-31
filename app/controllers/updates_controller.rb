class UpdatesController < ApplicationController

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

end