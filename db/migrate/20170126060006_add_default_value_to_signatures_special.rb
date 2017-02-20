class AddDefaultValueToSignaturesSpecial < ActiveRecord::Migration
  def change
    change_column_default :signatures, :special, 0
  end
end
