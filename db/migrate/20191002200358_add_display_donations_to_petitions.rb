class AddDisplayDonationsToPetitions < ActiveRecord::Migration
  def change
    add_column :petitions, :display_donations, :boolean, null: false, default: true, after: :special_count
  end
end
