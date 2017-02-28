require 'test_helper'

class InviteFormTest < ActiveSupport::TestCase
  include Concerns::StripWhitespace
  include Concerns::Transliterate

  test 'when valid, deliver should send message and return true' do
    assert_enqueued_jobs 1 do
      invite_form = InviteForm.new(
        mail: 'invite@example.com',
        signature: signatures(:four)
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

  test 'strip leading and trailing whitespace' do
    invite_form = InviteForm.new
    assert_strip_whitespace invite_form, :mail
  end

  test 'should convert accented characters in mail' do
    invite_form = InviteForm.new
    assert_transliterate invite_form, :mail
  end
end
