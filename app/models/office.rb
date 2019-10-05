class Office < ActiveRecord::Base
  default_scope { order('name ASC') }

  resourcify

  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :petitions

  belongs_to :organisation
  belongs_to :petition_type

  has_many :images, as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :images

  scope :visible, -> { where(hidden: false) }

  def self.default_office
    find_by(email: 'nederland@petities.nl')
  end
end
