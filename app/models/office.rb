class Office < ActiveRecord::Base
  default_scope { order('name ASC') }

  extend FriendlyId

  has_many :petitions

  has_many :images, as: :imageable, dependent: :destroy

  accepts_nested_attributes_for :images
end
