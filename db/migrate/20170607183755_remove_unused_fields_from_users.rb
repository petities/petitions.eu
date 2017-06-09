class RemoveUnusedFieldsFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :username
    remove_index :users, :confirmed
    remove_column :users, :confirmed
    remove_column :users, :persistence_token
    remove_column :users, :single_access_token
    remove_column :users, :perishable_token
    remove_column :users, :login_count
    remove_column :users, :failed_login_count
    remove_column :users, :last_request_at
    remove_column :users, :current_login_at
    remove_column :users, :last_login_at
    remove_column :users, :current_login_ip
    remove_column :users, :last_login_ip
  end
end
