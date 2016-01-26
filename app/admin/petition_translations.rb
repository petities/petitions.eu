ActiveAdmin.register PetitionTranslation do
  permit_params :locale,
                :name,
                :description,
                :initiators,
                :statement,
                :request,
                :slug

  # config.petitions = false
  # filter :name
  # filter :description
  # filter :required_minimum_age

  # filter :display_person_born_at
  # filter :require_person_born_at

  # filter :display_person_birth_city
  # filter :require_person_birth_city

  # filter :display_signature_person_citizen
  # filter :display_signature_full_address
  # filter :require_signature_full_address
end
