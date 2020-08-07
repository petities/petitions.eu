require 'test_helper'

class SignatureMailerTest < ActionMailer::TestCase
  include TestInDutchHelper

  setup do
    @signature = signatures(:four)
  end

  test 'handed_over_signatories_mail' do
    mail = SignatureMailer.handed_over_signatories_mail(@signature)

    assert_equal 'De petitie "De eerste petitie om mee te testen" is overhandigd!', mail.subject
    assert_equal ['test31@gmail.com'], mail.to
    assert_equal ['webmaster@petities.nl'], mail.from

  end

  test 'inform_user_of_answer_mail' do
    answer = updates(:one)
    mail = SignatureMailer.inform_user_of_answer_mail(@signature, answer)

    assert_equal 'Het eindresultaat voor de petitie "De eerste petitie om mee te testen"', mail.subject
    assert_equal ['test31@gmail.com'], mail.to
    assert_equal ['webmaster@petities.nl'], mail.from

  end

  test 'inform_user_of_news_update_mail' do
    update = updates(:one)
    mail = SignatureMailer.inform_user_of_news_update_mail(@signature, update)

    assert_equal 'Petitie "De eerste petitie om mee te testen", voortgangsbericht', mail.subject
    assert_equal ['test31@gmail.com'], mail.to
    assert_equal ['webmaster@petities.nl'], mail.from
  end

  test 'sig_confirmation_mail' do
    mail = SignatureMailer.sig_confirmation_mail(@signature)

    assert_equal 'Bevestig alstublieft uw ondertekening voor de petitie "De eerste petitie om mee te testen" (vertrouwelijk, stuur niet door)', mail.subject
    assert_equal ['test31@gmail.com'], mail.to
    assert_equal ['webmaster@petities.nl'], mail.from

    assert_match @signature.person_name, mail.body.encoded
    assert_match 'https://localhost/signatures/testkey/confirm', mail.body.encoded
  end

  test 'sig_reminder_confirm_mail' do
    mail = SignatureMailer.sig_reminder_confirm_mail(@signature)

    assert_equal 'Herinnering: bevestig alstublieft uw ondertekening voor de petitie "De eerste petitie om mee te testen" (vertrouwelijk, stuur niet door)', mail.subject
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

  test 'share_mail with person_function' do
    signature = signatures(:five)
    recipient = 'invite@example.com'
    mail = SignatureMailer.share_mail(signature, recipient)

    assert mail.to, recipient
    assert_match signature.person_name, mail.body.encoded
    assert_match 'met de aantekening', mail.body.encoded
    assert_match signature.person_function, mail.body.encoded
  end
end
