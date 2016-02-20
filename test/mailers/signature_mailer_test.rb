require 'test_helper'

class SignatureMailerTest < ActionMailer::TestCase
  test 'sig_confirmation_mail' do
    signature = signatures(:one)
    mail = SignatureMailer.sig_confirmation_mail(signature)

    assert_equal 'Bevestig alstublieft uw ondertekening voor de petitie "test1," (vertrouwelijk, stuur niet door)', mail.subject
    assert_equal ['test31@gmail.com'], mail.to
    assert_equal ['webmaster@petities.nl'], mail.from

    assert_match signature.person_name, mail.body.encoded
    assert_match 'https://localhost/signatures/testkey/confirm', mail.body.encoded
  end
end
