require 'json'
require 'base64'
require 'digest'

module IrmaHelper
  def irma_jwt_create
    # Creates a signed IRMA request in the form of a JSON web token (JWT)
    # to disclose the user's email address.

    return Irma::JWT::Create(:HS256, 
          Base64.urlsafe_decode64(Rails.configuration.irma_request_hmac_key), {
      :sub => "verification_request",
      :iss => Rails.configuration.irma_requestor,
      :iat => Time.now.to_i,
      :sprequest => {
        :request => {
          :@context => "https://irma.app/ld/request/disclosure/v2",
          :disclose => [[[ Rails.configuration.irma_email_attr ]]]
        }
      }
    })
  end
end
