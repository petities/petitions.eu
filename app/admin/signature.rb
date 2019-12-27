ActiveAdmin.register Signature do
  include AdminSignatures
  permit_params AdminSignatures::PERMITTED_PARAMS

  batch_action :invisible do |ids|
    batch_action_collection.find(ids).each do |signature|
      signature.visible = false
      signature.save
    end
    redirect_to collection_path, notice: t('active_admin.signatures.batch_invisible')
  end

  batch_action :unsubscribe do |ids|
    batch_action_collection.find(ids).each do |signature|
      signature.subscribe = false
      signature.more_information = false
      signature.save
    end
    redirect_to collection_path, notice: t('active_admin.signatures.batch_unsubscribe')
  end

  batch_action :disable_all do |ids|
    batch_action_collection.find(ids).each do |signature|
      signature.visible = false
      signature.subscribe = false
      signature.more_information = false
      signature.save
    end
    redirect_to collection_path, notice: t('active_admin.signatures.batch_disable_all')
  end

  index pagination_total: false do
    selectable_column
    id_column
    column :petition
    column :person_name
    column :person_city
    column :person_email
    column :visible
    column :signed_at
    column :confirmed_at
    actions
  end

  form do |f|
    f.inputs 'Signature Details' do
      f.input :person_name
      f.input :visible
      f.input :subscribe
      f.input :more_information
      f.input :person_function
      f.input :person_street
      f.input :person_street_number
      f.input :person_street_number_suffix
      f.input :person_postalcode
      f.input :person_city
      f.input :person_email
      f.input :special
      f.input :person_born_at
      f.input :person_dutch_citizen
      f.input :person_birth_city
      f.input :person_country, include_blank: true
      f.input :sort_order
    end
    f.actions
  end
end
