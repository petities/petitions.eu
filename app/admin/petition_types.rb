ActiveAdmin.register PetitionType do
  permit_params :name, :description, :required_minimum_age,
                :display_person_born_at, :display_person_birth_city,
                :require_person_born_at, :require_person_birth_city,
                :display_signature_person_citizen,
                :display_signature_full_address,
                :require_signature_full_address,
                :custom_additional_info_visible,
                :custom_additional_info_person_name,
                :custom_additional_info_person_street,
                :custom_additional_info_person_postalcode,
                :custom_additional_info_person_function,
                :custom_additional_info_subscribe,
                :custom_additional_info_person_birth_date,
                :custom_additional_info_person_birth_city,
                :custom_additional_info_person_dutch_citizen,
                :custom_additional_info_more_information, :country_code

  filter :name
  filter :description
  filter :required_minimum_age

  filter :display_person_born_at
  filter :require_person_born_at

  filter :display_person_birth_city
  filter :require_person_birth_city

  filter :display_signature_person_citizen
  filter :display_signature_full_address
  filter :require_signature_full_address
end
