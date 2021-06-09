require 'devise/strategies/authenticatable'

# Adds authentication via an IRMA JWT in params[:user][:irma_email]
#
# based in part on  https://gist.github.com/r00k/906356
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

        return nil, :irma_jwt_signature if disclosure.nil? 
        
        # check expiry
        exp = disclosure["exp"] 
        return nil, :irma_jwt_exp \
          unless (exp.is_a? Integer) and exp > Time.now.to_i

        # we do not when  disclosure["iat"] lies in the future,
        # because it might with clock drift, and so on.

        return nil, :irma_jwt_issuer \
          unless disclosure["iss"]=="irmaserver"
        return nil, :irma_jwt_subject \
          unless disclosure["sub"]=="disclosing_result"
        return nil, :irma_jwt_status \
          unless disclosure["status"]=="DONE"
        return nil, :irma_jwt_type \
          unless disclosure["type"]=="disclosing"
        return nil, :irma_jwt_proof_status \
          unless disclosure["proofStatus"]=="VALID"
        
        emailAttr = disclosure.dig("disclosed", 0, 0)
        
        return nil, :irma_missing if emailAttr.nil?
        return nil, :irma_status \
          unless emailAttr["status"]=="PRESENT"
        return nil, :irma_type \
          unless emailAttr["id"]==Rails.configuration.irma_email_attr

        email = emailAttr["rawvalue"]

        return nil, :irma_blank_email if email.blank?

        return User.find_by_email(email), nil
      end

      def authenticate!
        Irma.assert

        user, err = user_from_jwt params[:user][:irma_email]

        if !err.nil?
          fail! err
        elsif user.nil?
          fail! :irma_invalid_email
        else
          # confirm user, if they aren't already;  we must do this before
          # running 'succes! user' lest the user is not considered active
          # for authentication.
          user.confirm unless user.confirmed?

          # Make sure the user is remembered when the "Remember me" checkbox
          # is ticked.  The default database authentication uses this method
          # call as well, see:  
          #   https://github.com/heartcombo/devise/blob/c82e4cf47b02002b2fd7ca31d441cf1043fc634c/lib/devise/strategies/database_authenticatable.rb#L14
          remember_me(user)

          success! user
        end
      end
    end
  end
end

# It would be better to only add the irma_auth strategy when Irma.enabled?,
# but unfortunately, Rails.configuration is not yet loaded here.
Warden::Strategies.add(:irma_auth, Devise::Strategies::IrmaAuth)

