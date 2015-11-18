class Update < ActiveRecord::Base
  self.table_name = 'newsitems'
  extend FriendlyId

  # `title`.`title`, `title_clean`.`title_clean`,
  # `text`.`text`, `petition_id`.`petition_id`,
  # `office_id`.`office_id`, `url`.`url`,
  # `url_text`.`url_text`, `private_key`.`private_key`,
  # `date`.`date`, `date_from`.`date_from`,
  # `date_until`.`date_until`, `show_on_office`.`show_on_office`,
  # `show_on_home`.`show_on_home`,
  # `created_at`.`created_at`, `updated_at`.`updated_at`,
  # `cached_slug`.`cached_slug`

  # slug_column = 'cached_slug'

  friendly_id :title, use: :slugged, slug_column: :cached_slug

  default_scope { order('created_at DESC') }

  scope :website_news, -> { where(show_on_home: true, petition_id: nil, office_id: 5) }
  scope :show_on_home, -> { where(show_on_home: true) }

  belongs_to :petition
  belongs_to :office

  def intro_text
    # text.split('. ').slice(0, 2)
    return unless text
    text_array = text.split('. ').slice(0, 2)
    return text_array.join('. ').html_safe if text_array
  end

  def read_more_text
    return unless text

    text_array = text.split('. ').slice(2, text.length)
    text = text_array.join('. ').html_safe if text_array
    text
  end
end
