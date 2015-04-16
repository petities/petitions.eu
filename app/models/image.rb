class Image < ActiveRecord::Base
  belongs_to :imageable, :polymorphic => true
  
  validates_length_of :alt_label, :maximum => 255, :allow_blank => true
  
  has_attached_file :upload
  
end
