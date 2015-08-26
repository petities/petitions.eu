class DesksController < ApplicationController
  def index
    @offices = Office.all
  end

  def show
    @page = params[:page] || 1

    @office = Office.find(params[:id])
    @petitions = Petition.where(office_id: @office.id)
    @results_size = @petitions.size
    @petitions = @petitions.paginate(page: @page, per_page: 12)
  end
end