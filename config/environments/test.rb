Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.
  #
  config.action_mailer.default_url_options = {
    host: 'localhost:3000'
  }

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = { address: 'localhost', port: 1025 }
  ##
  config.action_mailer.perform_deliveries = false
  config.action_mailer.raise_delivery_errors = true

  # Devise user handling
  config.action_mailer.default_url_options = { host: 'localhost' }

  config.active_support.test_order = :random

  config.eager_load = false
end
