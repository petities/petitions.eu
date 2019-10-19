module AdminSignatures
  PERMITTED_PARAMS = [
    :petition_id, :person_name, :person_street, :person_street_number_suffix,
    :person_street_number, :person_postalcode, :person_function, :person_email,
    :person_dutch_citizen, :signed_at, :confirmed_at, :confirmed, :unique_key,
    :special, :person_city, :subscribe, :person_birth_city, :sort_order,
    :signature_remote_addr, :signature_remote_browser,
    :confirmation_remote_addr, :confirmation_remote_browser, :more_information,
    :visible, :person_born_at, :reminders_sent, :last_reminder_sent_at,
    :person_country
  ].freeze

  def self.included(dsl)
    dsl.actions :all, except: [:new]
    dsl.filter :petition_id

    dsl.filter :person_name
    dsl.filter :person_street
    dsl.filter :person_street_number
    dsl.filter :person_street_number_suffix

    dsl.filter :person_postal_code
    dsl.filter :person_function
    dsl.filter :person_email, filters: [:equals, :contains]
    dsl.filter :person_dutch_citizen

    dsl.filter :signed_at
    dsl.filter :created_at
    dsl.filter :updated_at

    dsl.filter :special
    dsl.filter :person_city
    dsl.filter :person_birth_city
    dsl.filter :person_born_at

    dsl.filter :signature_remote_browser
    dsl.filter :signature_remote_addr
    dsl.filter :signature_confirmation_remote_browser

    dsl.filter :more_information
    dsl.filter :visible

    dsl.filter :last_reminder_send_at
  end
end
