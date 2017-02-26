class AddIndexOnCreatedAtToNewSignatures < ActiveRecord::Migration
  def change
    add_index :new_signatures, [:created_at, :last_reminder_sent_at]
  end
end
