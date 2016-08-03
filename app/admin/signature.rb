ActiveAdmin.register Signature do
  permit_params :petition_id, :person_name, :person_street,
                :person_street_number_suffix, :person_street_number,
                :person_postalcode, :person_function, :person_email,
                :person_dutch_citizen, :signed_at, :confirmed_at,
                :confirmed, :unique_key, :special, :person_city, :subscribe,
                :person_birth_date, :person_birth_city, :sort_order,
                :signature_remote_addr, :signature_remote_browser,
                :confirmation_remote_addr, :confirmation_remote_browser,
                :more_information, :visible, :person_born_at, :reminders_sent,
                :last_reminder_sent_at, :unconverted_person_born_at,
                :person_country

  filter :petition_id

  filter :person_name
  filter :person_street
  filter :person_street_number
  filter :person_street_number_suffix

  filter :person_postal_code
  filter :person_function
  filter :person_email, filters: [:equals, :contains]
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
