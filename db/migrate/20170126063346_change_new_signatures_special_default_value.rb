class ChangeNewSignaturesSpecialDefaultValue < ActiveRecord::Migration
  def change
    change_column_null :new_signatures, :special, false, 0
    change_column_default :new_signatures, :special, 0
  end
end
