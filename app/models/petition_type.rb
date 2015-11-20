# == Schema Information
#
# Table name: petition_types
#
#  id                                          :integer          not null, primary key
#  name                                        :string(255)
#  description                                 :text(65535)
#  required_minimum_age                        :integer
#  created_at                                  :datetime
#  updated_at                                  :datetime
#  display_person_born_at                      :boolean
#  display_person_birth_city                   :boolean
#  require_person_born_at                      :boolean
#  require_person_birth_city                   :boolean
#  display_signature_person_citizen            :boolean
#  display_signature_full_address              :boolean
#  require_signature_full_address              :boolean
#  custom_additional_info_visible              :string(255)
#  custom_additional_info_person_name          :string(255)
#  custom_additional_info_person_street        :string(255)
#  custom_additional_info_person_postalcode    :string(255)
#  custom_additional_info_person_function      :string(255)
#  custom_additional_info_subscribe            :string(255)
#  custom_additional_info_person_birth_date    :string(255)
#  custom_additional_info_person_birth_city    :string(255)
#  custom_additional_info_person_dutch_citizen :string(255)
#  custom_additional_info_more_information     :string(255)
#  country_code                                :boolean
#

class PetitionType < ActiveRecord::Base
  has_many :petitions
  has_many :offices
end
