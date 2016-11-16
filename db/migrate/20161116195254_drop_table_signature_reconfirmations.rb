class DropTableSignatureReconfirmations < ActiveRecord::Migration
  def up
    drop_table :signatures_reconfirmations
  end
end
