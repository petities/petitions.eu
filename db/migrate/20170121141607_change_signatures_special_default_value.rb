class ChangeSignaturesSpecialDefaultValue < ActiveRecord::Migration
  def change
    change_column :signatures, :special, :boolean, default: false, null: false
  end
end
