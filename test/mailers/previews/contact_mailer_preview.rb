# Preview all emails at http://localhost:3000/rails/mailers/contact_mailer
class ContactMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/contact_mailer/webmaster_message
  def webmaster_message
    contact_form = ContactForm.new(
      name: 'Example Name',
      mail: 'name@example.com',
      message: 'I would like to send you a message'
    )
    ContactMailer.webmaster_message(contact_form)
  end
end
