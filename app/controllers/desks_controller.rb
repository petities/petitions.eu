class DesksController < ApplicationController
  include SortPetitions

  def index
    @offices = Office.all
  end

  def show

    if params[:id]
      @office = Office.find(params[:id])
    elsif request.subdomain
      @office = Office.find_by_subdomain(request.subdomain)
    end

    if not user_signed_in?
      show_not_logged_in
      return
    else
      show_office_page
    end
  end

  private

  def show_office_page
    @page = params[:page] || 1

    @petitions = Petition.where(office_id: @office.id)

    @results_size = @petitions.size

    petitions_by_status @petitions

    @users = User.order(:email)

    @office_admins = User.with_role(:admin, @office)

    @admins = User.with_role(:admin)
  end

  def show_not_logged_in

    petitions = Petition.where(office_id: @office.id)

    @petitions = sort_petitions petitions

    render 'show_not_logged_in'
  end
end

