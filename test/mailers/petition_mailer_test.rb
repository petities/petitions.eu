require 'test_helper'

class PetitionMailerTest < ActionMailer::TestCase
  setup :initialize_petition

  test 'ask_office_answer_due_date_mail' do
    mail = PetitionMailer.ask_office_answer_due_date_mail(@petition)
    assert_equal ["#{@petition.subdomain}@petities.nl"], mail.reply_to
    assert_equal [@petition.office.email], mail.to
    assert_equal "Weet u wanneer mijn petitie \"#{@petition.name}\" besproken wordt?", mail.subject
  end

  private

  def initialize_petition
    @petition = petitions(:one)
  end
end
