# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  email                  :string(255)
#  password_salt          :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  address                :string(255)
#  postalcode             :string(255)
#  city                   :string(255)
#  telephone              :string(255)
#  birth_date             :date
#  birth_city             :string(255)
#  encrypted_password     :string(255)
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_token         :string(255)
#  unconfirmed_email      :string(255)
#

class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  def valid_password?(password)
    super(password)
  rescue BCrypt::Errors::InvalidHash
    logger.info "not working password..check if it's the old style.."
    digest = "#{password}#{password_salt}"
    20.times do
      digest = Digest::SHA512.hexdigest(digest)
    end
    return false unless digest == encrypted_password
    logger.info "User #{email} is using the old password hashing method, updating attribute."
    self.password = password
    true
  end
end
