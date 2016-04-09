require 'test_helper'

class InviteFormTest < ActiveSupport::TestCase
  test 'when valid, deliver should send message and return true' do
    assert_enqueued_jobs 1 do
      invite_form = InviteForm.new(
        mail: 'invite@example.com',
        signature: signatures(:one)
      )
      assert invite_form.deliver
    end
  end

  test 'when invalid, deliver should not send message and return false' do
    assert_enqueued_jobs 0 do
      invite_form = InviteForm.new
      assert_not invite_form.deliver
    end
  end
end
