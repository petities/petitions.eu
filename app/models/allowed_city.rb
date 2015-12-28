# == Schema Information
#
# Table name: allowed_cities
#
#  id               :integer          not null, primary key
#  petition_type_id :integer
#  city_id          :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class AllowedCity < ActiveRecord::Base
  belongs_to :petition_type
  belongs_to :city
end
