class Newsletter < ActiveRecord::Base
  belongs_to :petition, required: true

  validates :date, :number, :text, presence: true
  validates :number, uniqueness: { scope: :petition_id }
end
