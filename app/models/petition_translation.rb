# == Schema Information
#
# Table name: petition_translations
#
#  id          :integer          not null, primary key
#  petition_id :integer          not null
#  locale      :string(255)      not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  name        :string(255)
#  description :text(65535)
#  initiators  :text(65535)
#  statement   :text(65535)
#  request     :text(65535)
#  slug        :string(255)
#

class PetitionTranslation < ActiveRecord::Base
  # has_many :petitions
  # has_many :offices

  # has_many :allowed_cities, :dependent => :destroy
  # has_many :cities, :through => :allowed_cities
end
