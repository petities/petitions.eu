class ProfileController < ApplicationController
  before_action :set_profile
  # load the edit my details page
  #
  # in the future load every instance of data
  # on each petition?

  def edit
    authorize :profile, :edit?
  end

  # update user data
  def patch
    authorize :profile, :edit?

    @profile.update_attributes(profile_params)
    redirect_to '/profile/edit'
  end

  private

  def profile_params
    params.require(:user).permit(
      :address,
      :email,
      :postalcode,
      :telephone,
      :birth_date,
      :city,
      :name
    )
  end

  def set_profile
    @profile = current_user
  end
end
