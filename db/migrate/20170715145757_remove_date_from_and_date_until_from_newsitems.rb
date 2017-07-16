class RemoveDateFromAndDateUntilFromNewsitems < ActiveRecord::Migration
  def change
    remove_index :newsitems, :date_from
    remove_index :newsitems, :date_until
    remove_column :newsitems, :date_from
    remove_column :newsitems, :date_until
  end
end
