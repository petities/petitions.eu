# == Schema Information
#
# Table name: offices
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  text              :text(65535)
#  url               :string(255)
#  hidden            :boolean
#  postalcode        :string(255)
#  email             :string(255)
#  organisation_id   :integer
#  organisation_kind :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  slug              :string(255)
#  subdomain         :string(255)
#  url_text          :string(255)
#  telephone         :string(255)
#  petition_type_id  :integer
#

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
