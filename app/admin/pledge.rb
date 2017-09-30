ActiveAdmin.register Pledge do
  permit_params :influence, :skill, :money, :feedback, :inform_me, :petition_id,
                :signature_id

  filter :petition_id
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

end
