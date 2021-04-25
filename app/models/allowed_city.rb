class AllowedCity < ApplicationRecord
  belongs_to :petition_type
  belongs_to :city
end
