class SignatureMailer < ApplicationMailer

  def confirmation_signature(signature)
    @signature = signature 

    puts @signature
    puts 'building a mail..'

    name = "noname"
    if @signature.petition.present?
      name = @signature.petition.name  
    end

    name = @signature.petition.present? | "nothing.."
    subject = t("signature.confirm", name: name)
    # beste x, bevestig uw handtekening voor petitie X
    @url = 'http://petitions.dev/confirm/code'

    m = mail(to: @signature.person_email, subject: subject)

    m.deliver

    puts 'email send?'
  end

end
