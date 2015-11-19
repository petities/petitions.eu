class Office < ActiveRecord::Base
  default_scope { order('name ASC') }

  extend FriendlyId

  friendly_id :name, :use => [:slugged, :finders], slug_column: :cached_slug
  #friendly_id :title, use: :slugged, slug_column: :cached_slug

  has_many :petitions

  has_many :images, as: :imageable, dependent: :destroy

  accepts_nested_attributes_for :images
end
