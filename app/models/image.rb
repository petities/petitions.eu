class Image < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true

  validates_length_of :alt_label, maximum: 255, allow_blank: true

  has_attached_file :upload, content_type: { content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif'] }

  validates_attachment_file_name :upload, matches: [/png\Z/, /jpe?g\Z/, /gif\Z/]
end
