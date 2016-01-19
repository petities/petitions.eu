class AddRoleIndex < ActiveRecord::Migration
  def up
    unless index_exists?(:roles, [:name, :resource_type, :resource_id])
      add_index(:roles, [:name, :resource_type, :resource_id])
    end

    unless index_exists?(:roles, [:authorizable_id])
      add_index(:roles, [:authorizable_id])
    end

    unless index_exists?(:roles, [:authorizable_type])
      add_index(:roles, [:authorizable_type])
    end
  end

  def down

  end
end
