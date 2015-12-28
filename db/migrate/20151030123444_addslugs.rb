class Addslugs < ActiveRecord::Migration
  def up
    # Petition.add_translation_fields! slug: :string
    add_column :petitions, :slug, :string
  end

  def down
    # Petition.remove_column :petition_translations, :slug
    # remove_column :petitions, :slug
  end
end
