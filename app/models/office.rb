# == Schema Information
#
# Table name: offices
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  name_clean        :string(255)
#  text              :text(65535)
#  url               :string(255)
#  hidden            :boolean
#  postalcode        :string(255)
#  email             :string(255)
#  organisation_id   :integer
#  organisation_kind :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  cached_slug       :string(255)
#  subdomain         :string(255)
#  url_text          :string(255)
#  telephone         :string(255)
#  petition_type_id  :integer
#

class Office < ActiveRecord::Base
  default_scope { order('name ASC') }

  extend FriendlyId

  friendly_id :name, :use => [:slugged, :finders], slug_column: :cached_slug
  #friendly_id :title, use: :slugged, slug_column: :cached_slug

  has_many :petitions

  belongs_to :organisation

  has_many :images, as: :imageable, dependent: :destroy

  accepts_nested_attributes_for :images

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
    return text_array.join('. ').html_safe if text_array
  end

end
