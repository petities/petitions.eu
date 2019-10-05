class RemoveColumnOfficeSuggestionFromPetitions < ActiveRecord::Migration
  def up
    remove_column :petitions, :office_suggestion
  end
end
