ActiveAdmin.register NewSignature do
  include AdminSignatures
  permit_params AdminSignatures::PERMITTED_PARAMS

  index pagination_total: false do
    selectable_column
    id_column
    column :petition
    column :person_name
    column :person_city
    column :person_email
    column :visible
    column :signed_at
    actions
  end
end
