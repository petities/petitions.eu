class RemoveNameCleanFromOffices < ActiveRecord::Migration
  def change
    remove_index :offices, name: :name_clean
    remove_column :offices, :name_clean
  end
end
