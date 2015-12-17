class AllowedCity < ActiveRecord::Base
  belongs_to :petition_type
  belongs_to :city
end

