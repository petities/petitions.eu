class AddLocaleToVersion < ActiveRecord::Migration
  def up
      add_column :versions, :locale, :string
  end
end
