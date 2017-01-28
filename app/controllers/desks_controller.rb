class DesksController < ApplicationController
  include SortPetitions

  before_filter :find_office, only: :show

  def index
    @offices = Office.visible
  end

  def show
    if user_signed_in? && current_user.has_role?(:admin, @office)
      show_office_page
      return
    else
      show_not_logged_in
    end
  end

  private

  def show_office_page
    @page = cleanup_page(params[:page])

    @petitions = Petition.where(office_id: @office.id)

    @results_size = @petitions.size

    petitions_by_status @petitions

    @users = User.order(:email)

    @office_admins = User.with_role(:admin, @office)

    @admins = Office.with_role(:admin, @office)
  end

  def show_not_logged_in
    petitions = Petition.where(office_id: @office.id)

    @petitions = sort_petitions petitions

    render 'show_not_logged_in'
  end

  def find_office
    @office = Office.friendly.find(params[:id])
    redirect_to(petition_desk_url(@office), status: 301) unless @office.friendly_id == params[:id]
  end
end
