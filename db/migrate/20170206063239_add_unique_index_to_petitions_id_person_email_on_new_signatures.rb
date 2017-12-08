class AddUniqueIndexToPetitionsIdPersonEmailOnNewSignatures < ActiveRecord::Migration
  def change
    add_index :new_signatures, [:petition_id, :person_email], unique: true
  end
end
