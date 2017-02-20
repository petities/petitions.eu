ActiveAdmin.register Office do
  include AdminImageSidebar
  permit_params :name, :text, :url, :hidden, :postalcode, :email,
                :organisation_id, :organisation_kind, :subdomain,
                :url_text, :telephone, :petition_type_id

  filter :name
  filter :subdomain
  filter :email, filters: [:equals, :contains]
  filter :postalcode
  filter :text
  filter :url
  filter :telephone

  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end
end
