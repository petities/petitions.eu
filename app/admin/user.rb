ActiveAdmin.register User do
  permit_params :email, :name, :telephone, :address, :postalcode, :city,
                :birth_date, :birth_city, :password, :password_confirmation,
                :petition_id, role_ids: []

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

  filter :email, filters: [:equals, :contains]
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at
  filter :roles

  show do
    attributes_table do
      row :email
      row :name
      row :telephone
      row :address
      row :postalcode
      row :city
      row :birth_date
      row :birth_city
    end

    panel 'user roles' do
      table_for user.roles do
        column :name
        column :resource_type
        column :resource_id
        column :name do |item|
          link_to(item.resource.name, [:admin, item.resource]) if item.resource
        end
      end
    end
  end

  form do |f|
    f.inputs 'User Details' do
      f.input :email
      f.input :name
      f.input :telephone
      f.input :address
      f.input :postalcode
      f.input :city
      f.input :birth_date
      f.input :birth_city
      f.input :password
      f.input :password_confirmation

      panel 'add petition role' do
        text_field_tag 'petition_id'
      end

      panel 'website roles' do
        f.input :roles, as: :check_boxes, collection: Role.without_resource
      end

      panel 'petition roles' do
        f.input :roles, as: :check_boxes,
          collection: Role.where(resource_type: 'Petition')
                          .where(id: user.roles.map { |r| r.id }),
          member_label:  Proc.new { |r| "%10s %30s" % [r.name ,Petition.find(r.resource_id).name ]}
      end


      panel 'office roles' do
        f.input :roles, as: :check_boxes, 
          collection: Role.where(resource_type: 'Office'),
          member_label: Proc.new { |r| "%10s %20s" % [r.name, Office.find(r.resource_id).name] }
      end

    end

    f.actions
  end

  controller do
    def update
      if params[:petition_id].present?
        petition = Petition.find(params[:petition_id])
        role = petition.roles.find_or_create_by(name: :admin)
        params[:user][:role_ids].push(role.id)
      end

      if params[:user][:password].blank?
        params[:user].delete('password')
        params[:user].delete('password_confirmation')
      end

      super
    end
  end
end
