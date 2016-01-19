class RenameOfficesCachedSlugsToSlugs < ActiveRecord::Migration
  def change
    remove_index :offices, :cached_slug
    rename_column :offices, :cached_slug, :slug
    add_index :offices, :slug, unique: true
  end
end
