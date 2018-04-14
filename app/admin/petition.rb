ActiveAdmin.register Petition do
  include AdminImageSidebar
  include AdminFriendlyIdFinder
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
                :reference_field, :answer_due_date, :office_id

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

  action_item :view, only: :show do
    link_to(t('active_admin.petitions.update_signature_count'), update_signature_count_admin_petition_path(resource), method: :put)
  end

  member_action :update_signature_count, method: :put do
    UpdateSignaturesCountJob.perform_later(resource)
    redirect_to([:admin, resource], notice: t('active_admin.petitions.update_signature_count_requested'))
  end

  sidebar :translations, only: :show do
    table_for resource.translations do
      column :id do |item|
        link_to(item.id, [:admin, item])
      end
      column :locale
    end
    link_to(
      I18n.t('active_admin.new_model', model: PetitionTranslation.model_name.human),
      new_admin_petition_translation_path(petition_translation: { petition_id: resource.id })
    )
  end

  sidebar :redis, only: :show do
    from_redis = { signature_count: RedisPetitionCounter.count(resource) }
    attributes_table_for from_redis do
      row :signature_count
    end
  end

  sidebar :users, only: :show do
    table_for resource.users do
      column :id do |item|
        link_to(item.id, [:admin, item])
      end
      column :name
    end
  end

  sidebar :newsletters, only: :show do
    table_for resource.newsletters do
      column :number do |item|
        link_to(item.number, [:admin, item])
      end
      column :date
    end
    link_to(
      I18n.t('active_admin.new_model', model: Newsletter.model_name.human),
      new_admin_newsletter_path(newsletter: { petition_id: resource.id })
    )
  end
end
