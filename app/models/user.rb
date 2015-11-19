class User < ActiveRecord::Base
  rolify
  # alias :devise_valid_password? :valid_password?
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # has_many :petitions, as: :owner

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
