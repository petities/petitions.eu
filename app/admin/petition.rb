ActiveAdmin.register Petition do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end
  index do
    selectable_column
    id_column
    column :name
    column :initiators
    column :date_projected
    column :petitioner_name
    column :petitioner_email
    column :signatures_count
    column :created_at
    column :updated_at
  end

  filter :name
  filter :subdomain
  filter :signatures_count
  filter :description
  filter :initiators
  filter :statement
  filter :request

  filter :updated_at
  filter :created_at
  filter :date_projected

  filter :petitioner_email
  filter :petitioner_city
  filter :status
  filter :archived
  filter :locale_list
end
