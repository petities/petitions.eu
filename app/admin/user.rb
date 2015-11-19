ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :telephone, role_ids: []

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    column :telephone
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
      row :telephone
    end

    panel "user roles" do
      table_for user.roles do
        column :name
        column :resource_type
        column :resource_id
      end
    end
  end

  form do |f|
    f.inputs 'User Details' do
      f.input :email
      f.input :telephone
      f.input :password
      f.input :password_confirmation

      panel "website roles" do
        f.input :roles, as: :check_boxes, collection: Role.where(resource_id: nil, resource_type: nil)

      end

      panel "office roles" do
        f.input :roles, as: :check_boxes, collection: Role.where(resource_type: 'Office').map{|r| [r.name + ' ' + Office.find(r.resource_id).name, r.id]}
      end

    end
    f.actions
  end

  controller do
    def update
      if params[:user][:password].blank?
        params[:user].delete('password')
        params[:user].delete('password_confirmation')
      end

      super
    end
  end

end
