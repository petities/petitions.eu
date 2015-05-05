class AddPetitionTranslations < ActiveRecord::Migration
  

  def up
    Petition.create_translation_table!({
      :name => :string, 
      :description => :text, 
      :initiators => :text, 
      :statement => :text, 
      :request => :text}, {
        :migrate_data => true
      })

  end

  def down 
    Petition.drop_translation_table!
  end
end
