class AddActiveRateValueToPetitions < ActiveRecord::Migration
  def change
    add_column :petitions, :active_rate_value, :decimal, default: 0
  end
end
