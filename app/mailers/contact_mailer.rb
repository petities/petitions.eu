# Send contact form to webmaster
class ContactMailer < ApplicationMailer
  def webmaster_message(contact_form)
    @contact_form = contact_form

    mail to: 'Stichting petities.nl <webmaster@petities.nl>',
         from: contact_form.mail,
         cc: contact_form.mail,
         sender: 'webmaster@petities.nl',
         subject: build_subject(contact_form.subject)
  end

  private

  def build_subject(subject)
    [t('.subject'), subject].reject(&:blank?).join(': ')
  end
end
