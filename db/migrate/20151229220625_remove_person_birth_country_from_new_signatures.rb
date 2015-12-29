class RemovePersonBirthCountryFromNewSignatures < ActiveRecord::Migration
  def change
    remove_column :new_signatures, :person_birth_country
  end
end
