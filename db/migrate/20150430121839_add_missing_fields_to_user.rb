class AddMissingFieldsToUser < ActiveRecord::Migration

  def change
    add_column :users, :confirmation_token, :string, :limit => 255
    add_column :users, :confirmed_at, :timestamp
    add_column :users, :confirmation_sent_at, :timestamp

    add_column :users, :reset_password_token, :string, :limit => 255
    add_column :users, :remember_token, :string, :limit => 255

    add_index :users, :email,                :unique => true
    add_index :users, :confirmation_token,   :unique => true
    add_index :users, :reset_password_token, :unique => true
    add_index :users, :unlock_token,         :unique => true

  end
end
