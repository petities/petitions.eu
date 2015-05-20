class RolifyCreateRoles < ActiveRecord::Migration

  def down
     drop_table :users_roles
  end

  def up

    if not Role.table_exists?

      create_table(:roles) do |t|
        t.string :name
        t.references :resource, :polymorphic => true

        t.timestamps
      end

      add_index(:roles, :name)

    else
      unless column_exists? :roles, :resource_type
       add_column :roles, :resource_type, :string
       add_column :roles, :resource_id, :int
       # Copy legacy data to new columns
       execute("update roles set resource_type=authorizable_type")
       execute("update roles set resource_id=authorizable_id")
       add_index(:roles, [:name, :resource_type, :resource_id ])
      end
    end

    def create_roles_table
      create_table(:users_roles, :id => false) do |t|
        t.references :user
        t.references :role
      end
      add_index(:users_roles, [:user_id, :role_id ])
      # add some basic roles
      Role.create!(name: 'admin')
      Role.create!(name: 'petitioner')
      Role.create!(name: 'editor')
    end

    if not ActiveRecord::Base.connection.table_exists? 'roles_users'
      if not ActiveRecord::Base.connection.table_exists? 'users_roles'
        execute "CREATE TABLE users_roles LIKE roles_users;"
        # copy existing data from roles_users into users_roles
        execute "INSERT users_roles SELECT * FROM roles_users;"
      else
        create_roles_table
      end
    else
      create_roles_table
    end
  end
end
