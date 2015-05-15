class User < ActiveRecord::Base
  rolify
  #alias :devise_valid_password? :valid_password?
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def valid_password?(password)
    begin
      super(password)
    rescue BCrypt::Errors::InvalidHash
      logger.info "not working password..check if it's the old style.."
      digest = "#{password}#{password_salt}"
      20.times {
        digest = Digest::SHA512.hexdigest(digest)
      }
      return false unless digest == encrypted_password
      logger.info "User #{email} is using the old password hashing method, updating attribute."
      self.password = password
      true
    end
  end

end
