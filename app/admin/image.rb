ActiveAdmin.register Image do
  permit_params :imageable_type, :imageable_id, :upload_file_name,
                :upload_content_type, :upload_file_size, :alt_label, :upload

  index do
    selectable_column
    id_column
    column :imageable do |item|
      link_to(item.imageable.try(:name, :title), [:admin, item.imageable])
    end
    column :upload do |item|
      image_tag(item.upload.url, class: 'upload-image')
    end
    column :created_at
    actions
  end

  sidebar :image, only: :show do
    image_tag(resource.upload.url, class: 'upload-image')
  end

  form do |f|
    f.inputs 'Image Details' do
      f.input :imageable_type
      f.input :imageable_id
      f.input :upload_file_name
      f.input :upload_content_type
      f.input :upload_file_size
      f.input :alt_label
      f.input :upload, as: :file#, hint: f.template.image_tag(f.object.upload.url, style: 'max-width: 500px')
    end
    f.actions
  end
end
