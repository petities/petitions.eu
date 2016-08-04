class CleanupRoles < ActiveRecord::Migration
  def change
    drop_table :roles_users
    remove_index :roles, :authorizable_type
    remove_index :roles, :authorizable_id
    remove_column :roles, :authorizable_type
    remove_column :roles, :authorizable_id
  end
end
