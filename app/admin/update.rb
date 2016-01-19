
#  title            :string(255)
#  title_clean      :string(255)
#  text             :text(4294967295)
#  petition_id      :integer
#  office_id        :integer
#  url              :string(255)
#  url_text         :string(255)
#  private_key      :string(255)
#  date             :date
#  date_from        :date
#  date_until       :date
#  show_on_office   :boolean
#  show_on_home     :boolean
#  created_at       :datetime
#  updated_at       :datetime
#  cached_slug      :string(255)
#  show_on_petition :boolean

ActiveAdmin.register Update do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted


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
      f.input :created_at
      f.input :updated_at
    end
  end
end
