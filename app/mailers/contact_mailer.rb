class ContactMailer < ApplicationMailer
  def webmaster_message(contact_form)
    @contact_form = contact_form

    mail to: 'webmaster@petities.nl',
         from: 'webmaster@petities.nl',
         cc: contact_form.mail,
         sender: contact_form.mail
  end
end
