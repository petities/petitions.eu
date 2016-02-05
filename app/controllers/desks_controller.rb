class DesksController < ApplicationController
  include SortPetitions

  def index
    @offices = Office.all
  end

  def show
    if params[:id]
      @office = Office.friendly.find(params[:id])
    elsif request.subdomain
      @office = Office.find_by_subdomain(request.subdomain)
    end

    @signatures_count = 0
    #@signatures_count = Signature.joins(:petition)
    #                    .where(petitions: { office_id: @office.id }).size
    Petition.where(office_id: @office.id).all.each do |p|
      @signatures_count += p.get_count
    end

    if user_signed_in? && current_user.has_role?(:admin, @office)
      show_office_page
      return
    else
      show_not_logged_in
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

    @admins = Office.with_role(:admin, @office)
  end

  def show_not_logged_in
    petitions = Petition.where(office_id: @office.id)

    @petitions = sort_petitions petitions

    render 'show_not_logged_in'
  end
end
