ActiveAdmin.register Signature do
  include AdminSignatures
  permit_params AdminSignatures::PERMITTED_PARAMS

  index pagination_total: false do
    selectable_column
    id_column
    column :petition
    column :person_name
    column :person_city
    column :person_email
    column :person_function
    column :signed_at
    column :confirmed_at
    actions
  end
end
