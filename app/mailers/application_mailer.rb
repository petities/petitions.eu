class ApplicationMailer < ActionMailer::Base
  default from: "noreply@petitions.eu"
  layout 'mailer'

  def contact_mail(from, subject, body)
    mail(to: 'website@petities.nl', from: from, subject: 'Message from Petities.nl', body: body)
  end
end
