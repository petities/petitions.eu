class AddIndexOnPetitionIdSlugAndLocaleToPetitionTranslations < ActiveRecord::Migration
  def change
    add_index :petition_translations, [:petition_id, :slug, :locale]
  end
end
