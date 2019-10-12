class Update < ActiveRecord::Base
  self.table_name = 'newsitems'

  before_validation :fill_date

  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  default_scope { order('created_at DESC') }

  scope :show_on_home, -> { where(show_on_home: true) }

  belongs_to :petition
  belongs_to :office

  has_many :images, as: :imageable, dependent: :destroy

  validates :title, presence: true
  validates :text, presence: true

  def slug_candidates
    [:title, [:title, :date]]
  end

  private

  def fill_date
    self.date = Time.zone.today if date.blank?
  end
end
