class AddOwnerIdToPetition < ActiveRecord::Migration
  def change
    add_column :petitions, :owner_id, :integer
  end
end
