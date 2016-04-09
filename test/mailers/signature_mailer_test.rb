require 'test_helper'

class SignatureMailerTest < ActionMailer::TestCase
  setup do
    @signature = signatures(:one)
  end

  test 'sig_confirmation_mail' do
    mail = SignatureMailer.sig_confirmation_mail(@signature)

    assert_equal 'Bevestig alstublieft uw ondertekening voor de petitie "test1," (vertrouwelijk, stuur niet door)', mail.subject
    assert_equal ['test31@gmail.com'], mail.to
    assert_equal ['webmaster@petities.nl'], mail.from

    assert_match @signature.person_name, mail.body.encoded
    assert_match 'https://localhost/signatures/testkey/confirm', mail.body.encoded
  end

  test 'sig_reminder_confirm_mail' do
    mail = SignatureMailer.sig_reminder_confirm_mail(@signature)

    assert_equal 'Herinnering: bevestig alstublieft uw ondertekening voor de petitie "test1," (vertrouwelijk, stuur niet door)', mail.subject
    assert_equal ['test31@gmail.com'], mail.to
    assert_equal ['webmaster@petities.nl'], mail.from

    assert_match @signature.person_name, mail.body.encoded
    assert_match 'test@test.nl', mail.body.encoded
    assert_match 'https://localhost/signatures/testkey/confirm', mail.body.encoded
  end

  test 'share_mail' do
    recipient = 'invite@example.com'
    mail = SignatureMailer.share_mail(@signature, recipient)

    assert mail.to, recipient
    assert_match @signature.person_name, mail.body.encoded
  end
end
