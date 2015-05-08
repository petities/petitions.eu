class AddLocalesToPetition < ActiveRecord::Migration
  def change
   add_column :petitions, :locale_list, :text
  end
end
