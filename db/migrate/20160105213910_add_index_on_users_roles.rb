class AddIndexOnUsersRoles < ActiveRecord::Migration
  def up

    unless index_exists?(:users_roles, [:user_id, :role_id])
    add_index :users_roles, [:user_id, :role_id]
    end
  end

  def down

  end
end
