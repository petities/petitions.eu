class RolifyCreateRoles < ActiveRecord::Migration

  def down

  end

  def up

    if not Role.table_exist?
      create_table(:roles) do |t|
        t.string :name
        t.references :resource, :polymorphic => true

        t.timestamps
      end
    end

    create_table(:users_roles, :id => false) do |t|
      t.references :user
      t.references :role
    end

    add_column :roles, :resource_type, :string
    add_column :roles, :resource_id, :int

    # Copy data to new columns
    execute("update roles set resource_type=authorizable_type")
    execute("update roles set resource_id=authorizable_id")

    add_index(:roles, :name)
    add_index(:roles, [ :name, :resource_type, :resource_id ])
    add_index(:users_roles, [:user_id, :role_id ])

    Role.create!(name: 'admin')
    Role.create!(name: 'petitioner')
    Role.create!(name: 'editor')

  end
end
