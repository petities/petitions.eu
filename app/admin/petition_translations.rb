ActiveAdmin.register PetitionTranslation do
  permit_params :petition_id, :locale, :name, :description, :initiators,
                :statement, :request, :slug

  form do |f|
    f.semantic_errors
    f.inputs do
      if resource.petition
        f.input :petition_id, as: :hidden
      else
        f.input :petition
      end
      f.input :locale
      f.input :name
      f.input :description
      f.input :initiators
      f.input :statement
      f.input :request
      f.input :slug
    end
    f.actions
  end

end
