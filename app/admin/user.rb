ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, role_ids: []

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at
  filter :roles

  show do
 
    attributes_table do
      row :email
      row :first_name
      row :last_name
    end

    table_for  user.roles do
      column "Role" do |role|
        role.name
      end
    end
  end

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :roles, as: :check_boxes, collection: Role.where({
        resource_id: nil, resource_type: nil})
    end
    f.actions
  end
end
