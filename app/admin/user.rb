ActiveAdmin.register User do
  permit_params :email, :name, :telephone, :address, :postalcode, :city,
                :birth_date, :birth_city, :password, :password_confirmation,
                :petition_id, role_ids: []

  index do
    selectable_column
    column :name do |item|
      link_to(item.name, [:admin, item])
    end
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    column :telephone
    actions
  end

  filter :name
  filter :email, filters: [:equals, :contains]
  filter :current_sign_in_at
  filter :sign_in_count
  filter :reset_password_sent_at
  filter :created_at

  action_item :resend_confirmation_instructions, only: :show do
    link_to(t('active_admin.users.resend_confirmation_instructions'), resend_confirmation_instructions_admin_user_path(resource), method: :put) unless resource.confirmed?
  end

  member_action :resend_confirmation_instructions, method: :put do
    resource.resend_confirmation_instructions
    redirect_to([:admin, resource], notice: t('active_admin.users.confirmation_instructions_resent'))
  end

  show do
    columns do
      column do
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
      end
      column do
        attributes_table title: t('active_admin.users.account_usage') do
          row :created_at
          row :updated_at
          row :confirmed_at
          row :confirmation_sent_at unless resource.confirmed?
          row :current_sign_in_at
          row :current_sign_in_ip
          row :last_sign_in_at
          row :last_sign_in_ip
          row :sign_in_count
        end
      end
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
