class DesksController < ApplicationController
  include SortPetitions

  skip_before_action :ensure_domain, only: :redirect

  def index
    @offices = Office.all
  end

  def show
    if params[:id]
      @office = Office.friendly.find(params[:id])
    elsif request.subdomain
      @office = Office.find_by_subdomain(request.subdomain)
    end

    if user_signed_in? && current_user.has_role?(:admin, @office)
      show_office_page
      return
    else
      show_not_logged_in
    end
  end

  def redirect
    @office = Office.find_by_subdomain(request.subdomain)
    redirect_to petition_desk_url(@office, subdomain: nil, locale: nil)
  end

  private

  def show_office_page
    @page = params[:page] || 1

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
end
