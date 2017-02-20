class AddUploadProcessingToImages < ActiveRecord::Migration
  def change
    add_column :images, :upload_processing, :boolean
  end
end
