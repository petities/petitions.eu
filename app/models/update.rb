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
