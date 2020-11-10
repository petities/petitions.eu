ActiveAdmin.register Newsletter do
  permit_params :petition_id, :number, :status, :published, :publish_from,
                :messages_count, :text, :date

  filter :number
  filter :published
  filter :date

  # Remove create button on index page, as petition_id is always required
  config.action_items.delete_at(0)

  index do
    selectable_column
    id_column
    column :petition
    column :date
    column :number
    column :status
    column :messages_count
    column :published
    column :created_at
    actions
  end

  form do |f|
    f.inputs 'Newsletter fields' do
      f.input :petition_id, as: :hidden
      f.input :number
      f.input :date
      f.input :messages_count
      f.input :text
    end
    actions
  end

end
