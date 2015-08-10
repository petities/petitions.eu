class AddOwnerTypeToPetition < ActiveRecord::Migration
  def change
    add_column :petitions, :owner_type, :string
  end
end
