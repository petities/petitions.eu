# Preview all emails at http://localhost:3000/rails/mailers/petition_mailer
class PetitionMailerPreview < ActionMailer::Preview

  #ask signatories with any pledge to adopt orphaned petition
  def adoption_request_signatory_mail
    petition = Petition.where(status: 'live').first
    PetitionMailer.adoption_request_signatory_mail(Signature.last.petition, Signature.last)
  end

  # ask office which date petition should get an answer
  def ask_office_answer_due_date_mail
    petition = Petition.where(status: 'live').first
    PetitionMailer.ask_office_answer_due_date_mail(Petition.live.first)
  end

  # ask office for answer to petition
  def ask_office_for_answer_mail
    petition = Petition.where(status: 'live').first
    PetitionMailer.ask_office_for_answer_mail(Petition.live.first)
  end

  # call petitioner into action about closing petition <10 signatures
  def due_next_week_warning_mail_small
    petition = Petition.find(169)
    PetitionMailer.due_next_week_warning_mail(Petition.live.first)
  end

  # call petitioner into action about closing petition >10 signatures
  def due_next_week_warning_mail_big
    petition = Petition.find(6317)
    PetitionMailer.due_next_week_warning_mail(Petition.live.first)
  end


  # finalize petition, ready for moderation
  def finalize_mail
    petition = Petition.where(status: 'live').first
    PetitionMailer.finalize_mail(Petition.live.first)
  end

  # petitioner with failed petition asked to fix it
  def improve_and_reopen_mail
    petition = Petition.where(status: 'live').first
    PetitionMailer.improve_and_reopen_mail(Petition.live.first)
  end

  # announce petition to office
  def petition_announcement_mail
    petition = Petition.where(status: 'live').first
    PetitionMailer.petition_announcement_mail(Petition.live.first)
  end

  # explain office what we expect
  def process_explanation_mail
    petition = Petition.where(status: 'live').first
    PetitionMailer.process_explanation_mail(Petition.live.first)
  end

  # ask office for reference number  
  def reference_number_mail
    petition = Petition.where(status: 'live').first
    PetitionMailer.reference_number_mail(Petition.live.first)
  end

  # each petition status change by e-mail to admin
  def status_change
    petition = Petition.where(status: 'live').first
    PetitionMailer.status_change_mail(Petition.live.first)
  end

  # a virtual hand over of the signatories list
  def hand_over_to_office_mail
    petition = Petition.where(status: 'live').first
    PetitionMailer.hand_over_to_office_mail(Petition.live.first)
  end

  # petitioner is asked to write an update about the hand over
  def write_about_hand_over_mail
    petition = Petition.where(status: 'live').first
    PetitionMailer.write_about_hand_over_mail(Petition.live.first)
  end

  # ask petitioner to confirm, give user and password
  def welcome_petitioner_mail
    password = Devise.friendly_token.first(8)
    PetitionMailer.welcome_petitioner_mail(Petition.first, User.first, password)
  end

end
