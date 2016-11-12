ActiveAdmin.register PetitionTranslation do
  permit_params :petition_id, :locale, :name, :description, :initiators,
                :statement, :request, :slug


end
