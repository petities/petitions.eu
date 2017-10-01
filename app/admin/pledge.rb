ActiveAdmin.register Pledge do
  permit_params :influence, :skill, :money, :feedback, :inform_me, :petition_id,
                :signature_id

  filter :petition_subdomain_equals
  filter :signature_person_name_contains
  filter :signature_person_email_equals
  filter :influence
  filter :skill
  filter :money
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    id_column
    column :petition
    column :signature
    column :influence
    column :skill
    column :money
    column :created_at
    actions
  end

  controller do
    def scoped_collection
      end_of_association_chain.includes(:petition).includes(:signature)
    end
  end
end
