ActiveAdmin.register User do
  permit_params :email, :first_name, :last_name, 
                :password, :password_confirmation, 
                :telephone, :petition_id, role_ids: []

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
      row :first_name
      row :last_name
      row :telephone
    end

    panel 'user roles' do
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

      panel 'add petition role' do
        text_field_tag 'petition_id'
      end

      panel 'website roles' do
        f.input :roles, as: :check_boxes, collection: Role.where(resource_id: nil, resource_type: nil)
        #f.input :roles, as: :check_boxes, collection: user.roles #Role.where(resource_id: nil, resource_type: nil)
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
      if not params[:petition_id].blank?
        #petition = Petition.find(params[:petition_id])
        #user = User.find(params[:id])

        role = Role.where(
          resource_id: params[:petition_id], 
          resource_type: 'Petition').first

        if role
          params[:user][:role_ids].push(role.id)
        end

        #if petition
        #  user.add_role(:admin, petition)
        #  user.save
        #end

      end

      if params[:user][:password].blank?
        params[:user].delete('password')
        params[:user].delete('password_confirmation')
      end

      super
    end
  end
end
