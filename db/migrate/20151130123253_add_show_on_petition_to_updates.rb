class AddShowOnPetitionToUpdates < ActiveRecord::Migration
  def change
    add_column :newsitems, :show_on_petition, :boolean
  end
end
