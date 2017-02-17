require 'test_helper'

class ContactFormTest < ActiveSupport::TestCase
  test 'when valid, deliver should send message and return true' do
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      contact_form = ContactForm.new(
        name: 'Example Name',
        mail: 'name@example.com',
        subject: 'Message to test',
        message: 'I would like to send you a message'
      )
      assert contact_form.deliver
    end
  end

  test 'when invalid, deliver should not send message and return false' do
    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      contact_form = ContactForm.new
      assert_not contact_form.deliver
    end
  end
end
