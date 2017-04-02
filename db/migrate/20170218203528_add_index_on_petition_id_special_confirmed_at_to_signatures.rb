class AddIndexOnPetitionIdSpecialConfirmedAtToSignatures < ActiveRecord::Migration
  def change
    add_index :signatures, [:petition_id, :special, :confirmed_at]
  end
end
