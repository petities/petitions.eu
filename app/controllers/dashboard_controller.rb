class DashboardController < ApplicationController
  include SortPetitions

  before_action :authenticate_user!

  def show
    @petitions = Petition.with_role(:admin, current_user)

    petitions_by_status @petitions
  end
end
