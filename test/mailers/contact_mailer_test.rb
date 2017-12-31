require 'test_helper'

class ContactMailerTest < ActionMailer::TestCase
  include TestInDutchHelper

  setup do
    @contact_form = ContactForm.new(
      name: 'Example Name',
      mail: 'name@example.com',
      subject: 'Message to test',
      message: 'I would like to send you a message.',
      remote_ip: '127.0.0.1',
      browser: 'Mozilla/5.0 (iPad; U; CPU OS 3_2_1 like Mac OS X; en-us)'
    )
  end

  test 'webmaster_message with subject' do
    mail = ContactMailer.webmaster_message(@contact_form)
    assert_equal "Bericht vanaf petities.nl: #{@contact_form.subject}", mail.subject
    assert_equal ['webmaster@petities.nl'], mail.to
    assert_equal 'webmaster@petities.nl', mail.sender
    assert_equal [@contact_form.mail], mail.cc
    assert_equal [@contact_form.mail], mail.from

    [:name, :mail, :message, :subject, :remote_ip, :browser].each do |attribute|
      assert_match @contact_form.send(attribute), mail.body.encoded
    end
  end

  test 'webmaster_message without subject' do
    @contact_form.subject = ''
    mail = ContactMailer.webmaster_message(@contact_form)
    assert_equal 'Bericht vanaf petities.nl', mail.subject
  end
end
