class AddIndexOnPetitionTranslationsName < ActiveRecord::Migration
  def change
    add_index :petition_translations, :name
  end
end
