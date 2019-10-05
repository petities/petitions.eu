class PetitionType < ActiveRecord::Base
  has_many :petitions
  has_many :offices

  has_many :allowed_cities, dependent: :destroy
  has_many :cities, through: :allowed_cities
end
