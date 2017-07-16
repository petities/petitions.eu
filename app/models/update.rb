# == Schema Information
#
# Table name: newsitems
#
#  id               :integer          not null, primary key
#  title            :string(255)
#  text             :text(4294967295)
#  petition_id      :integer
#  office_id        :integer
#  url              :string(255)
#  url_text         :string(255)
#  private_key      :string(255)
#  date             :date
#  date_from        :date
#  date_until       :date
#  show_on_office   :boolean
#  show_on_home     :boolean
#  created_at       :datetime
#  updated_at       :datetime
#  slug             :string(255)
#  show_on_petition :boolean
#

class Update < ActiveRecord::Base
  self.table_name = 'newsitems'

  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]

  default_scope { order('created_at DESC') }

  scope :website_news, -> { where(show_on_home: true, petition_id: nil, office_id: 5) }
  scope :show_on_home, -> { where(show_on_home: true) }

  # review
  # publish

  belongs_to :petition
  belongs_to :office

  has_many :images, as: :imageable, dependent: :destroy

  before_save :fill_date

  # not empty update!

  private

  def fill_date
    self.date = Time.zone.today if date.blank?
  end
end
