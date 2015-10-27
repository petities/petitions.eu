class AddCountryToSignatures < ActiveRecord::Migration

  def up
    add_column :new_signatures, :person_birth_country, :string, :limit => 2
    add_column :new_signatures, :person_country, :string, :limit => 2
    add_column :signatures, :person_birth_country, :string, :limit => 2
    add_column :signatures, :person_country, :string, :limit => 2
  end

  def down
    remove_column :new_signatures, :person_birth_country, :string
    remove_column :new_signatures, :person_country, :string
    remove_column :signatures, :person_birth_country, :string
    remove_column :signatures, :person_country, :string
  end
end
