# Preview all emails at http://localhost:3000/rails/mailers/signature_mailer
class SignatureMailerPreview < ActionMailer::Preview

  def confirm_mail
    SignatureMailer.sig_confirmation_mail(NewSignature.first)
  end

  # all signatories get a mail that the hand over took place
   def handed_over_signatories_mail
     petition = Petition.where(status: 'live').first
     SignatureMailer.handed_over_signatories_mail(Signature.last)
   end

  # signatory gets the answer to the petition
  def inform_user_of_answer_mail
    petition = Petition.where(status: 'live').first
    answer = petition.updates.where(show_on_petition: true).first
    SignatureMailer.inform_user_of_answer_mail(Signature.last, petition, answer)
  end
  
  def reminder_mail
    SignatureMailer.sig_reminder_confirm_mail(NewSignature.first)
  end

  def share_mail
    SignatureMailer.share_mail(Signature.first, 'test@petitions.eu')
  end
  def share_mail2
    SignatureMailer.share_mail(Signature.last, 'test@petitions.eu')
  end
end
