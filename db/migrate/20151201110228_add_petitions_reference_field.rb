class AddPetitionsReferenceField < ActiveRecord::Migration
  def change
    add_column :petitions, :reference_field, :string
  end
end
