class PetitionTranslation < ActiveRecord::Base
  belongs_to :petition
  # has_many :petitions
  # has_many :offices

  # has_many :allowed_cities, :dependent => :destroy
  # has_many :cities, :through => :allowed_cities
end
