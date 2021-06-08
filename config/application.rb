require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PetitionApp
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Europe/Amsterdam'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]

    config.i18n.available_locales = [:nl, :en, :de, :frl, :nl_gr, :cat]

    config.i18n.default_locale = :nl
    config.i18n.enforce_available_locales = false
    config.i18n.fallbacks = true
    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.autoload_paths << Rails.root.join('lib')

    config.active_job.queue_adapter = :sidekiq

    config.middleware.use Rack::Attack


    # To add IRMA authentication, change
    config.irma = false # to true

    # Users can then login with the following attribute:
    config.irma_email_attr = "pbdf.sidn-pbdf.email.email"

    # You must run an irma server behind a publically accessible URL:
    config.irma_server_url = "https://your-irma.server/irma-api-prefix"

    # The IRMA server url must be https for the IRMA app to accept.  
    # To achieve this it might be easiest to run irma server without https 
    # at your-irma.server, and have a http server like lighttpd 
    # add https by proxy, by adding to  /etc/lighttpd/lighttpd.conf:
    #
    # $HTTP["host"] == "your-irma.server" {
    #   $HTTP["url"] =~ "^/irma-api-prefix/" {
    #     proxy.server = ( "" => ( ( "host" => "127.0.0.1",
    #                                "port" => "8088" ) ) )
    #   }
    # }
    
    # Requests directed towards the IRMA server are signed using HMAC.
    config.irma_requestor = "petities"
    config.irma_request_hmac_key = "Q8K1H8KUw7gbwqXCscOtw6rDniAuwqzDhwkuw6rDqMKH"
    # And responses from the IRMA server are signed using RSA.
    config.irma_server_public_key = <<~END_OF_KEY 
      -----BEGIN PUBLIC KEY-----
      MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA19I/wHqplFBk5Dr8+T04
      er462JCWTO6gaG2xm5SPPKfJ8/o1Ia2sxLAafi8hVJc50qk3oFmouqYKwTk/V9/J
      tjtgL5gYWunDP1fd72XUZZf1+EYviytgFns3zbgGiqPBHIZCnzSlJTbRqjspJTLB
      YbFhvx6rdSlQxj5gkAZwo70ZSXAzZn+Uym90yp+vn013lPTM5wx6d0bTprsmQsyR
      BQfHNs0AyA04wfSJ46HS7QfcOuBwDgW4j7vwcn8hnCSIirEmL8PsXF+ivG7T9OO1
      J39JY21NJzeQx3/bu0gFlhDf0zXPF1tyBAekbvJEN1SdQlwl6R02YR/Xq2wnK+bL
      UwIDAQAB
      -----END PUBLIC KEY-----
      END_OF_KEY

    # These secrets coincide with the ones for the IRMA server below,
    # but should, of course, be replaced by your own.

    # An irma server (without https) can be run by:
    #
    # $  irma server -vv -a /irma-api-prefix --production --no-email
    #
    # with in its working directory a file irmaserver.yaml:
    #
    # requestors:
    #   petities:
    #     auth_method: hmac 
    #     key: Q8K1H8KUw7gbwqXCscOtw6rDniAuwqzDhwkuw6rDqMKH
    # no_auth: false
    # url: https://your-irma.server/api-prefix/irma
    # jwt_privkey: |2
    #   -----BEGIN RSA PRIVATE KEY-----
    #   MIIEpQIBAAKCAQEA19I/wHqplFBk5Dr8+T04er462JCWTO6gaG2xm5SPPKfJ8/o1
    #   Ia2sxLAafi8hVJc50qk3oFmouqYKwTk/V9/JtjtgL5gYWunDP1fd72XUZZf1+EYv
    #   iytgFns3zbgGiqPBHIZCnzSlJTbRqjspJTLBYbFhvx6rdSlQxj5gkAZwo70ZSXAz
    #   Zn+Uym90yp+vn013lPTM5wx6d0bTprsmQsyRBQfHNs0AyA04wfSJ46HS7QfcOuBw
    #   DgW4j7vwcn8hnCSIirEmL8PsXF+ivG7T9OO1J39JY21NJzeQx3/bu0gFlhDf0zXP
    #   F1tyBAekbvJEN1SdQlwl6R02YR/Xq2wnK+bLUwIDAQABAoIBAQCfLtIa095UKF/h
    #   /qgr5T3NOpYIucxB/heOLqo7SH3FjTRloXyi1IiDoihIPdbln4zkli8TNE5BLMrt
    #   7Z2M4ODUakLtl88O7zA1fkeRlZftPwILFylmCp4attNYBo28oD+FHHnzF09ffWlz
    #   l6MnbqI3vi+MWcC477pGHif20uktuqaMKm19FZpIM1exuN3XpAv5YJWDI7Kqlym9
    #   JtkNBiByeS2ZF0cPA2CVEPhDM1+dQRC99R8xBT2v/tXtYf0fCxeDGdUhUpfRdwlW
    #   YIt/sfQ1mvcIT+aWhXvC3yoLdurpU8KRM1xJIJPT5b35zgk7jwgp1/NsN2ZnW7SO
    #   gUQ4AQmhAoGBAPombY9luqQ7wSnAJWG9Kwaaj6uuMVZWK86Dy/uzQx5LfoUra1RT
    #   rK8FqCq+0yC1tLfzMG7NcmtIisZXe5KAgFqlzympHH74u5D1OlBsZOCMPiKYU5wb
    #   Ebl/Frk4K+ytbnmqgxvqTEQLbiC2uOUoV3cCZ0xjj5cCCwAtRf6BBOa7AoGBANze
    #   Tg7efM+bProwRyWT6aCf1G04w87MSPo0Khl58aqa+uD84FfzDlsxC+7Ye5jS1Ye+
    #   rf81DIZEfQESFdEtCErtCskwzoGLr13wNSvRovtVXJpTNCKfxO64o7RENXlTv5+H
    #   /BsSNuJcwAR1Su1wf4df5BYYz4CDPgDHkwU68wBJAoGAVXf7xxsDAkpIXXOBUjvI
    #   D6GPpSEHSnB210DA2WcOb7NrryR+r3lHbyWHp9M7X9m1vYQh8DnR9kX65HnPhubQ
    #   9Cfi+GEHk3p427ZuDjx62x4PvNI+/v9gtvhtUyuWFm/LZ1aTJV6QYE9neVX1Jpb6
    #   C3eOw9LgpL/V8mGFoMeEXTECgYEA1/0Jhp7qnTcrA3bczJG2AV7rpJfDXEMIBq3m
    #   kZ1fyD/goQ6J8Vf+LQ1spvjK/WsIZ8P/cbgV9GObfuWJslIAbw0Z5B+3gpXwO8QA
    #   q0ZJxND4Su6c6FMniW/Eny+ov2o31TFtR6frRjf/ixyM1l+SRvduHHHM0dcGVkrU
    #   qmO4aQkCgYEAlfcOmIRgDAorzjX6It2H9sTdV+bktx82d3F7zo/yT/YBjBCi8bOy
    #   CULz3kM+DWXFLu2Bl4LPkge2xXJ9no/6A6gLqpvh5uSk53Mi8+lrJHebFEjsb5jK
    #   rgRORzM1nANAhvy3FucxKiNSqPA8GcO8eroHYqaB0P3etsvtUazG7LM=
    #   -----END RSA PRIVATE KEY-----
  end
end
