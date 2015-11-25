class AddCountryToType < ActiveRecord::Migration
  def change
    add_column :petition_types, :country_code, :boolean
  end
end
