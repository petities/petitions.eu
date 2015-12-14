# == Schema Information
#
# Table name: newsitems
#
#  id               :integer          not null, primary key
#  title            :string(255)
#  title_clean      :string(255)
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
#  cached_slug      :string(255)
#  show_on_petition :boolean
#

class Update < ActiveRecord::Base
  self.table_name = 'newsitems'
  extend FriendlyId

  friendly_id :title, :use => [:slugged, :finders], slug_column: :cached_slug

  default_scope { order('created_at DESC') }

  scope :website_news, -> { where(show_on_home: true, petition_id: nil, office_id: 5) }
  scope :show_on_home, -> { where(show_on_home: true) }

  belongs_to :petition
  belongs_to :office

  def intro_text
    # text.split('. ').slice(0, 2)
    return unless text
    text_array = text.split('. ').slice(0, 2)
    text_array.push('')
    return text_array.join('. ').html_safe if text_array
  end

  def read_more_text
    return unless text

    text_array = text.split('. ').slice(2, text.length)
    text = text_array.join('. ').html_safe if text_array
    text
  end
end
