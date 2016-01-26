class RemoveTitleCleanFromNewsitems < ActiveRecord::Migration
  def change
    remove_column :newsitems, :title_clean

    remove_index :newsitems, :cached_slug
    rename_column :newsitems, :cached_slug, :slug
    add_index :newsitems, :slug, unique: true
  end
end
