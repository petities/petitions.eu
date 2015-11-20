# == Schema Information
#
# Table name: images
#
#  id                  :integer          not null, primary key
#  imageable_id        :integer
#  imageable_type      :string(255)
#  upload_file_name    :string(255)
#  upload_content_type :string(255)
#  upload_file_size    :integer
#  upload_updated_at   :datetime
#  created_at          :datetime
#  updated_at          :datetime
#  alt_label           :string(255)
#

class Image < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true

  validates_length_of :alt_label, maximum: 255, allow_blank: true

  has_attached_file :upload, content_type: { content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif'] }

  validates_attachment_file_name :upload, matches: [/png\Z/, /jpe?g\Z/, /gif\Z/]
end
