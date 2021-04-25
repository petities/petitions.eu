class SignatureReminderJob < ActiveJob::Base
  queue_as :default

  def perform(signature)
    SignatureMailer.sig_reminder_confirm_mail(signature).deliver_now
  rescue Net::SMTPSyntaxError
    signature.destroy
  end
end
