ActiveAdmin.register Role do
  permit_params :id, :name, :resource_type, :resource_id

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :name, as: :select, collection: Role.group(:name).pluck(:name)
      f.input :resource_type, as: :select, collection: ['Petition', 'Office']
      f.input :resource_id
    end
    f.actions
  end

  sidebar :users, only: :show do
    table_for resource.users do
      column :id do |item|
        link_to(item.id, [:admin, item])
      end
      column :name
    end
  end

end
