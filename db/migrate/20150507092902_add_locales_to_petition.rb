class AddLocalesToPetition < ActiveRecord::Migration
  def up
    add_column :petitions, :locale_list, :text
  end

  def down
  end
end
