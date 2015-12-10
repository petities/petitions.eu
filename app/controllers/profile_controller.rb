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
    #  format.html { redirect_to edit_petition_path(@petition), flash: { success: 'Petition was successfully updated.' } }
    redirect_to '/profile/edit'
  end

  private

  def profile_params
    params.require(:user).permit(
      :address,
      :postalcode,
      :telephone,
      :birth_date,
      :city,
      :name,
    )
  end

  def set_profile
    @profile = current_user
  end

end
