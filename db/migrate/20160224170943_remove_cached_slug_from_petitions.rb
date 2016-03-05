class RemoveCachedSlugFromPetitions < ActiveRecord::Migration
  def change
    remove_column :petitions, :cached_slug
  end
end
