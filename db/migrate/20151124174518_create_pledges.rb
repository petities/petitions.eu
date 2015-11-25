class CreatePledges < ActiveRecord::Migration
  def up
    create_table :pledges do |t|
      t.column :influence, :string, :limit => 255
      t.column :skill, :string, :limit => 255
      t.column :money, :integer, :default => 0
      t.column :feedback, :string
      t.column :inform_me, :boolean
      t.references :petition, index: true
      t.references :signature, index: true
      t.timestamps null: false
    end

    add_index :pledges, [:petition_id, :signature_id], unique: true
  end

  def down
    drop_table :pledges
  end

end
