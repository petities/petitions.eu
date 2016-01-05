class ContactMailer < ApplicationMailer
  def webmaster_message(contact_form)
    @contact_form = contact_form

    mail to: 'webmaster@petities.nl',
         from: 'webmaster@petities.nl',
         sender: contact_form.mail
  end
end
