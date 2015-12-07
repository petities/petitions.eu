# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  username               :string(255)
#  name                   :string(255)
#  email                  :string(255)
#  confirmed              :boolean          default(FALSE), not null
#  crypted_password       :string(255)
#  password_salt          :string(255)
#  persistence_token      :string(255)
#  single_access_token    :string(255)
#  perishable_token       :string(255)
#  login_count            :integer          default(0), not null
#  failed_login_count     :integer          default(0), not null
#  last_request_at        :datetime
#  current_login_at       :datetime
#  last_login_at          :datetime
#  current_login_ip       :string(255)
#  last_login_ip          :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  address                :string(255)
#  postalcode             :string(255)
#  city                   :string(255)
#  telephone              :string(255)
#  birth_date             :date
#  birth_city             :string(255)
#  encrypted_password     :string(255)      default("")
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  remember_token         :string(255)
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
