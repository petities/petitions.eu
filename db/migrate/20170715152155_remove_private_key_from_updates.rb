class RemovePrivateKeyFromUpdates < ActiveRecord::Migration
  def change
    remove_column :newsitems, :private_key
  end
end
