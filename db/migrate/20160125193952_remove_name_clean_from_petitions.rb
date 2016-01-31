class RemoveNameCleanFromPetitions < ActiveRecord::Migration
  def change
    remove_index :petitions, name: :name_clean
    remove_column :petitions, :name_clean
    remove_column :petitions, :delta
  end
end
