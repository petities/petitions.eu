class AddIndexOnUsersRoles < ActiveRecord::Migration
  def change
    add_index :users_roles, [:user_id, :role_id]
  end
end
