class ChangeDefaultValueOnPetitionsDisplayDonations < ActiveRecord::Migration
  def change
    change_column_default :petitions, :display_donations, 0
  end
end
