ActiveAdmin.register Organisation do
  permit_params :id, :name, :kind, :code, :region,
                :created_at, :updated_at, :visible
end
