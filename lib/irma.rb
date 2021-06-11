require 'base64'
require 'json'
require 'openssl'

module Irma
  def self.enabled?
    return Rails.configuration.irma
  end

  def self.assert
    raise "IRMA support not yet configured" if not enabled?
  end

  module JWT
    ALGS = [ :HS256, :RS256 ]

    def self.Create(alg, key, payload) 
      # Creates (and signs) a JWT using the specified key and algorithm.
      #
      #  - payload will be put into JSON.generate( ... )
      #  - key should be 
      #    :HS256 => a binary string (not hex- or b64-encoded) 
      #    :RS256 => a PEM encoded private RSA key
      raise "Unknown algorithm #{alg}" unless ALGS.include?(alg)

      header_b64 = Base64.urlsafe_encode64(JSON.generate({
        :alg => alg,
        :typ => "JWT"
      }, :padding=>false))

      payload_b64 = Base64.urlsafe_encode64(JSON.generate(payload), 
                                          :padding=>false)

      msg = header_b64 + "." + payload_b64

      return msg+"."+Base64.urlsafe_encode64(Irma.sign(alg, key, msg), 
                                           :padding=>false)
    end

    def self.Open(jwt, key) 
      # Checks a JWT with the specified (public) key; returns nil otherwise
      header_b64, payload_b64, signature_b64 = jwt.split(".", 3)

      header = JSON.parse(Base64.urlsafe_decode64(header_b64))
      
      return nil unless header.has_key? "alg"
      alg = header["alg"].to_sym
      return nil unless  ALGS.include?(alg) and header["typ"]=="JWT"
  
      return nil unless Irma.verify(alg, key, header_b64 + "." + payload_b64,
                                    Base64.urlsafe_decode64(signature_b64))

      return JSON.parse(Base64.urlsafe_decode64(payload_b64))
    end
  end


  protected

  def self.hs256(key, text)
      return OpenSSL::HMAC.digest('sha256', key, text)
  end

  def self.sign(alg, key, text)
    case alg
    when :HS256
      return hs256(key, text)
    when :RS256
      return OpenSSL::PKey::RSA.new(key).sign(OpenSSL::Digest::SHA256.new, text)
    else
      raise "Unknown algorithm #{alg}"
    end
  end

  def self.verify(alg, key, text, signature)
    case alg
    when :HS256
      return hs256(key, text) == signature
    when :RS256
      return OpenSSL::PKey::RSA.new(key).verify(OpenSSL::Digest::SHA256.new,
                                               signature, text)
    else
      raise "Unknown algorithm #{alg}"
    end

  end
end
