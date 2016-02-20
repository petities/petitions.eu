class ApplicationMailer < ActionMailer::Base
  default from: 'Stichting petities.nl <webmaster@petities.nl>'
  layout 'mailer'

  before_action :add_return_path

  private

  # Return-Path will be used as envelope sender and will receive bounces.
  def add_return_path
    headers['Return-Path'] = 'bounces@petities.nl'
  end
end
