require 'test_helper'

class SignatureReminderJobTest < ActiveJob::TestCase
  include TestInDutchHelper

  setup do
    @signature = new_signatures(:one)
  end

  test 'should send reminder_mail to signatory' do
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      SignatureReminderJob.perform_now(@signature)
    end
    reminder_email = ActionMailer::Base.deliveries.last

    assert_equal 'Herinnering: bevestig alstublieft uw ondertekening voor de petitie "De eerste petitie om mee te testen" (vertrouwelijk, stuur niet door)', reminder_email.subject
    assert_equal @signature.person_email, reminder_email.to[0]
  end
end
