# Send contact form to webmaster
class ContactMailer < ApplicationMailer
  def webmaster_message(contact_form)
    @contact_form = contact_form

    mail to: 'webmaster@petities.nl',
         from: contact_form.mail,
         cc: contact_form.mail,
         sender: 'webmaster@petities.nl'
  end
end
