# Preview all emails at http://localhost:3000/rails/mailers/signature_mailer
class SignatureMailerPreview < ActionMailer::Preview

  def confirm_mail
    SignatureMailer.sig_confirmation_mail(NewSignature.first)
  end

  def reminder_mail
    SignatureMailer.sig_reminder_confirm_mail(NewSignature.first)
  end

  def share_mail
    SignatureMailer.share_mail(NewSignature.first, 'test@petitions.eu')
  end
  def share_mail2
    SignatureMailer.share_mail(NewSignature.last, 'test@petitions.eu')
  end

end
