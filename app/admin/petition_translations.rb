ActiveAdmin.register PetitionTranslation do
  permit_params :petition_id, :locale, :name, :description, :initiators,
                :statement, :request, :slug
  includes :petition

  filter :locale, filters: [:equals, :contains]
  filter :name
  filter :description

  index do
    selectable_column
    id_column
    column :petition
    column :locale
    column :name
    column :description
    actions
  end

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
