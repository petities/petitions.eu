# == Schema Information
#
# Table name: cities
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  imported_at   :datetime
#  imported_from :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

class City < ActiveRecord::Base
end
