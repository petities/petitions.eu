class SignatureMailer < ApplicationMailer
  def sig_confirmation_mail(signature)
    puts 'building a mail..xxx'
    @signature = signature

    puts @signature
    puts 'building a mail..'

    # find the petition name
    name = 'noname'
    name = @signature.petition.name if @signature.petition.present?

    name = @signature.petition.present? | 'nothing..'
    # beste x, bevestig uw handtekening voor petitie X
    subject = t('signature.confirm', name: name)
    # settings

    mail(to: @signature.person_email, subject: subject)
  end


  def share_mail(signature, target_email)

    @petition = @signature.petition

    mail(to: target_email, subject: subject)
  end
end
