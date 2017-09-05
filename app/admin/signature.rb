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
end
