class ChangeActiveRateValueFormatInPetitions < ActiveRecord::Migration
  def change
    change_column :petitions, :active_rate_value, :float, default: 0.0
  end
end
