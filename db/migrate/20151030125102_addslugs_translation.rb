class AddslugsTranslation < ActiveRecord::Migration

  def up
    Petition.add_translation_fields! slug: :string
  end

  def down
    Petition.remove_column :petition_translations, :slug
  end
end
