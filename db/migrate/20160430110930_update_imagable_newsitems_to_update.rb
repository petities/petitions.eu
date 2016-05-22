class UpdateImagableNewsitemsToUpdate < ActiveRecord::Migration
  def up
    Image.where(imageable_type: 'Newsitem').update_all(imageable_type: 'Update')
  end

  def down
    Image.where(imageable_type: 'Update').update_all(imageable_type: 'Newsitem')
  end
end
