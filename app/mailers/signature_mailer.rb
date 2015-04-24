class SignatureMailer < ApplicationMailer

  def sig_confirmation_mail(signature)
    puts 'building a mail..xxx'
    @signature = signature

    puts @signature
    puts 'building a mail..'

    # find the petition name
    name = "noname"
    if @signature.petition.present?
      name = @signature.petition.name
    end

    name = @signature.petition.present? | "nothing.."
    # beste x, bevestig uw handtekening voor petitie X
    subject = t("signature.confirm", name: name)
    # settings
    @url = 'http://dev.petitions.eu/confirm/code'
    #

    m = mail(to: @signature.person_email, subject: subject)

    # deliver it now!
    #  TODO QUEUE
    m.deliver

  end

end
