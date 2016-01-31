ActiveAdmin.register Update do
  permit_params :title, :text, :petition_id, :office_id, :show_on_home,
                :show_on_office, :show_on_petition

  filter :title
  filter :text
  filter :show_on_office
  filter :show_on_home
  filter :show_on_petition
  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs 'News fields' do
      f.input :title
      f.input :text
      f.input :show_on_office
      f.input :show_on_home
      f.input :show_on_petition
    end
    actions
  end
end
