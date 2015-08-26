class Update < ActiveRecord::Base
  self.table_name = 'newsitems'

  default_scope { order('created_at DESC') }

  scope :website_news, -> { where(show_on_home: true, petition_id: nil, office_id: 5) }
  scope :show_on_home, -> { where(show_on_home: true) }

  belongs_to :petition

  def intro_text
    self.text.split('. ').first.html_safe
  end

  def read_more_text
    self.text.split('. ').last.html_safe
  end
end