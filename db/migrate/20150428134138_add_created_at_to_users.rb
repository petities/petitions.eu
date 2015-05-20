class AddCreatedAtToUsers < ActiveRecord::Migration
  def self.up
   # create new password field
   execute "Alter table users add column encrypted_password varchar(255);"
   # migrate old hashes
   execute "Update users SET encrypted_password = crypted_password;"
   add_column :users, :remember_created_at, :datetime
   ## Trackable
   add_column :users, :sign_in_count, :integer, :default => 0
   add_column :users, :current_sign_in_at, :datetime
   add_column :users, :last_sign_in_at, :datetime
   add_column :users, :current_sign_in_ip, :string
   add_column :users, :last_sign_in_ip, :string

   add_column :users, :confirmation_token, :string, :limit => 255
   add_column :users, :confirmed_at, :timestamp
   add_column :users, :confirmation_sent_at, :timestamp

   add_column :users, :reset_password_token, :string, :limit => 255
   add_column :users, :remember_token, :string, :limit => 255

   add_index :users, :email,                :unique => true
   add_index :users, :confirmation_token,   :unique => true
   add_index :users, :reset_password_token, :unique => true

  end

  def self.down
    #remove_column :users, :remember_created_at
    #remove_column :users, :sign_in_count
    #remove_column :users, :current_sign_in_at
    #remove_column :users, :last_sign_in_at
    #remove_column :users, :current_sign_in_ip
    #remove_column :users, :last_sign_in_ip
  end
end
