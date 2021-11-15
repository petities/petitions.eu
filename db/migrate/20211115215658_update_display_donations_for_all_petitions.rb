class UpdateDisplayDonationsForAllPetitions < ActiveRecord::Migration
  def change
    Petition.update_all(display_donations: false)
  end
end
