require 'test_helper'

class ContactMailerTest < ActionMailer::TestCase
  test 'webmaster_message' do
    contact_form = ContactForm.new(
      name: 'Example Name',
      mail: 'name@example.com',
      message: 'I would like to send you a message.'
    )
    mail = ContactMailer.webmaster_message contact_form
    assert_equal 'Message from petities.nl', mail.subject
    assert_equal ['webmaster@petities.nl'], mail.to
    assert_equal ['webmaster@petities.nl'], mail.from
    assert_equal contact_form.mail, mail.sender

    [:name, :mail, :message].each do |attribute|
      assert_match contact_form.send(attribute), mail.body.encoded
    end
  end
end
