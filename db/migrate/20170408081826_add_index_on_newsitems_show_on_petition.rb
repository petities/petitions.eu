class AddIndexOnNewsitemsShowOnPetition < ActiveRecord::Migration
  def change
    add_index :newsitems, [:petition_id, :show_on_petition, :created_at], name: "index_newsitems_on_p_id_and_show_on_p_and_created_at"
  end
end
