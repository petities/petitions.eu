require 'test_helper'

class PetitionMailerTest < ActionMailer::TestCase
  setup :initialize_petition

  test 'ask_office_answer_due_date_mail' do
    mail = PetitionMailer.ask_office_answer_due_date_mail(@petition)
    assert_default_office_mail_attributes(mail)
    assert_equal "Weet u wanneer mijn petitie \"#{@petition.name}\" besproken wordt?", mail.subject
    assert_match '1 januari 2016', mail.body.encoded
  end

  test 'ask_office_for_answer_mail' do
    mail = PetitionMailer.ask_office_for_answer_mail(@petition)
    assert_default_office_mail_attributes(mail)
    assert_equal "Het is zover, heeft u een antwoord op de petitie \"#{@petition.name}\"?", mail.subject
    assert_match '1 januari 2016', mail.body.encoded
  end

  test 'hand_over_to_office_mail' do
    mail = PetitionMailer.hand_over_to_office_mail(@petition)
    assert_default_office_mail_attributes(mail)
    assert_equal "Bij deze de ondertekenaars van de petitie", mail.subject
    assert_match '1 januari 2016', mail.body.encoded
  end

  test 'petition_announcement_mail' do
    mail = PetitionMailer.petition_announcement_mail(@petition)
    assert_default_office_mail_attributes(mail)
    assert_equal "Graag een overhandigingsdatum voor deze petitie", mail.subject
    assert_match '1 januari 2016', mail.body.encoded
  end

  test 'process_explanation_mail' do
    mail = PetitionMailer.process_explanation_mail(@petition)
    assert_default_office_mail_attributes(mail)
    assert_equal "Komt de petitie \"#{@petition.name}\" op de agenda of is het ter kennisgeving?", mail.subject
  end

  test 'reference_number_mail' do
    mail = PetitionMailer.reference_number_mail(@petition)
    assert_default_office_mail_attributes(mail)
    assert_equal "Heeft u een referentienummer voor mijn petitie \"#{@petition.name}\"?", mail.subject
    assert_match '1 januari 2016', mail.body.encoded
  end

  test 'welcome_petitioner_mail' do
    password = 'example-password'
    user = users(:two)
    mail = PetitionMailer.welcome_petitioner_mail(@petition, user, password)

    assert_equal ['webmaster@petities.nl'], mail.from
    assert_equal [user.email], mail.to
    assert_equal ['webmaster@petities.nl'], mail.bcc
    assert_equal "Verder met uw petitie \"#{@petition.name}\" met deze inloggegevens", mail.subject

    assert_match password, mail.body.encoded
    assert_match @petition.petitioner_name, mail.body.encoded
    assert_match @petition.office.email, mail.body.encoded
    # assert_match @petition.office.telephone, mail.body.encoded
  end

  private

  # Messages to petition office share recipient, reply-to and from.
  def assert_default_office_mail_attributes(mail)
    assert_equal ["#{@petition.subdomain}@petities.nl"], mail.reply_to
    assert_equal ['webmaster@petities.nl'], mail.from
    assert_equal [@petition.office.email], mail.to
  end

  def initialize_petition
    @petition = petitions(:one)
    @petition.date_projected = Date.new(2016, 01, 01)
  end
end
