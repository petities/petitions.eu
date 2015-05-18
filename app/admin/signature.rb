ActiveAdmin.register Signature do


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

  filter :person_name
  filter :person_street
  filter :person_street_number
  filter :person_street_number_suffix

  filter :person_postal_code
  filter :person_function
  filter :person_email
  filter :person_dutch_citizen

  filter :signed_at
  filter :created_at
  filter :updated_at

  filter :special
  filter :person_city
  filter :person_birth_city 
  filter :person_born_at

  filter :signature_remote_browser
  filter :signature_remote_addr
  filter :signature_confirmation_remote_browser

  filter :more_information
  filter :visible

  filter :last_reminder_send_at
  filter :unconverted_person_born_at

end
