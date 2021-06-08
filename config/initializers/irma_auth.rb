require 'devise/strategies/authenticatable'

# Adds authentication via an IRMA JWT in params[:user][:irma_email]
#
# based on  https://gist.github.com/r00k/906356
module Devise
  module Strategies
    class IrmaAuth < Authenticatable
      def valid?
        return !params.dig(:user, :irma_email).blank?
      end

      def user_from_jwt(jwt)
        return nil if jwt.blank?

        disclosure = Irma::JWT.Open(jwt, 
          Rails.configuration.irma_server_public_key)

        return nil, "Invalid (signature on) disclosure JWT" if disclosure.nil? 
        
        # check expiry
        exp = disclosure["exp"] 
        return nil, "Expired disclosure JWT" \
          unless (exp.is_a? Integer) and exp > Time.now.to_i

        # we do not when  disclosure["iat"] lies in the future,
        # because it might with clock drift, and so on.

        return nil, "Invalid JWT issuer" \
          unless disclosure["iss"]=="irmaserver"
        return nil, "Invalud JWT subject" \
          unless disclosure["sub"]=="disclosing_result"
        return nil, "Invalid JWT status" \
          unless disclosure["status"]=="DONE"
        return nil, "Invalid JWT disclosure type"\
          unless disclosure["type"]=="disclosing"
        return nil, "Invalid JWT proof status"\
          unless disclosure["proofStatus"]=="VALID"
        
        emailAttr = disclosure.dig("disclosed", 0, 0)
        
        return nil, "No attribute in disclosure" if emailAttr.nil?
        return nil, "Invalid attribute status" \
          unless emailAttr["status"]=="PRESENT"
        return nil, "Disclosed attribute is not a: " + 
          Rails.configuration.irma_email_attr  \
          unless emailAttr["id"]==Rails.configuration.irma_email_attr

        email = emailAttr["rawvalue"]

        return nil, "Blank email" if email.blank?

        return User.find_by_email(email), nil
      end

      def authenticate!
        user, err = user_from_jwt params[:user][:irma_email]

        if !user.nil? and err.nil?
          success! user
        else
          if err.nil?
            fail! "Failed to log in with IRMA:  unknown email"
          else
            fail! "Failed to log in with IRMA: " + err
          end
        end
      end
    end
  end
end

Warden::Strategies.add(:irma_auth, Devise::Strategies::IrmaAuth)


