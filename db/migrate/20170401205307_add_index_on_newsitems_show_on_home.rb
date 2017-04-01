class AddIndexOnNewsitemsShowOnHome < ActiveRecord::Migration
  def change
    add_index :newsitems, [:show_on_home, :created_at]
  end
end
