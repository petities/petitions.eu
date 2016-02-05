ActiveAdmin.register Organisation do

  permit_params :id, :name, :kind, :code, :region,
                :created_at, :updated_at, :visible   
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end


end
