class AddNameToPetitions < ActiveRecord::Migration
  def change
    add_column :petitions, :name, :string
    add_column :petitions, :email, :string
  end
end
