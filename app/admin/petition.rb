ActiveAdmin.register Petition do
  permit_params :name, :subdomain, :description, :initiators, :statement,
                :request, :date_projected, :organisation_id,
                :organisation_name, :petitioner_organisation,
                :petitioner_birth_date, :petitioner_birth_city,
                :petitioner_name, :petitioner_address, :petitioner_postalcode,
                :petitioner_city, :petitioner_email, :petitioner_telephone,
                :maps_query, :office_suggestion, :organisation_kind, :link1,
                :link2, :link3, :link1_text, :link2_text, :link3_text, :site1,
                :site1_text, :signatures_count, :number_of_signatures_on_paper,
                :number_of_newsletters_sent, :cached_slug, :last_confirmed_at,
                :status, :manager_id, :show_twitter, :show_history, :show_map,
                :twitter_query, :lat_lng, :lat_lng_sw, :lat_lng_ne,
                :special_count, :display_more_information,
                :display_signature_person_citizen,
                :display_signature_full_address, :archived, :petition_type_id,
                :display_person_born_at, :display_person_birth_city,
                :active_rate_value, :owner_id, :owner_type, :slug,
                :reference_field, :answer_due_date, :office_id,
                locale_list: []

  index do
    selectable_column
    id_column
    column :name
    column :subdomain
    column :status
    column :initiators
    column :office
    column :organisation
    column :date_projected
    column :petitioner_name
    column :petitioner_email
    column :signatures_count
    column :created_at
    column :updated_at
  end

  filter :name
  filter :id
  filter :subdomain
  filter :organisation
  filter :office
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

  sidebar :images, only: :show do
    images = resource.images.map do |image|
      link_to(
        image_tag(image.upload.url, class: 'upload-image'), [:admin, image]
      )
    end
    raw(images.join)
  end
end
