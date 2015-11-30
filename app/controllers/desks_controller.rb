class DesksController < ApplicationController

  def index
    @offices = Office.all
  end

  def show
    @page = params[:page] || 1

    if params[:id]
      @office = Office.find(params[:id])
    elsif request.subdomain
      @office = Office.find_by_subdomain(request.subdomain)
    end
    @petitions = Petition.where(office_id: @office.id)

    @results_size = @petitions.size

    # find petition in state of allow
    @petitions_allow = @petitions.where("status IN ('draft', 'concept', 'staging')").limit(20)
    # find petitions in state of answer
    @petitions_answer = @petitions.where("status IN ('to_process', 'in_process')").limit(20)
    # find petition in state of signable
    @petitions_live = @petitions.live.limit(20)
    # find petition in state of answered
    @petitions_completed = @petitions.where(status: 'completed').limit(20)
    # find petition in state of done/ingetrokken
    @petitions_rejected = @petitions.where(status: 'rejected').limit(20)
    # withdrawn..
    @petitions_withdrawn = @petitions.where(status: 'withdrawn').limit(20)
    # @petitions = @petitions.paginate(page: @page, per_page: 12)
    #
    @users = User.order(:email)

    @office_admins = User.with_role(:admin, @office)

    @admins = User.with_role(:admin)
  end
end

