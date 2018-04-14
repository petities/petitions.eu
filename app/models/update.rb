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
#  date             :date
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
  friendly_id :title, use: :slugged

  default_scope { order('created_at DESC') }

  scope :show_on_home, -> { where(show_on_home: true) }

  # review
  # publish

  belongs_to :petition
  belongs_to :office

  has_many :images, as: :imageable, dependent: :destroy

  validates :title, presence: true
  validates :text, presence: true

  before_save :fill_date

  private

  def fill_date
    self.date = Time.zone.today if date.blank?
  end
end
