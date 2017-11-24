class RemoveInformMeFromPledges < ActiveRecord::Migration
  def up
    remove_column :pledges, :inform_me
  end
end
