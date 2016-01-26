ActiveAdmin.register City do
  permit_params :name, :imported_at, :imported_from
end
