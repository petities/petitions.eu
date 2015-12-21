# Preview all emails at http://localhost:3000/rails/mailers/petition_mailer
class PetitionMailerPreview < ActionMailer::Preview

  def status_change
    PetitionMailer.status_change_mail(Petition.live.first)
  end

  def finalize_mail
    PetitionMailer.finalize_mail(Petition.live.first)
  end

  def due_next_week_warning_mail
    PetitionMailer.due_next_week_warning_mail(Petition.live.first)
  end

  def write_about_hand_over_mail
    PetitionMailer.write_about_hand_over_mail(Petition.live.first)
  end

  def improve_and_reopen_mail
    PetitionMailer.improve_and_reopen_mail(Petition.live.first)
  end

  def petition_announcement_mail
    PetitionMailer.petition_announcement_mail(Petition.live.first)
  end

  def announcement_reminder_mail
    PetitionMailer.announcement_reminder_mail(Petition.live.first)
  end

  def default_signatories_answer_mail
    PetitionMailer.default_signatories_answer_mail(Petition.live.first)
  end

  def process_explanation_mail
    PetitionMailer.process_explanation_mail(Petition.live.first)
  end

  def virtual_hand_over_mail
    PetitionMailer.virtual_hand_over_mail(Petition.live.first)
  end

  def handed_over_signatories_mail
    PetitionMailer.handed_over_signatories_mail(Petition.live.first)
  end

  def inform_user_of_answer_mail  
    petition = Petition.where(status: 'live').first
    signature = petition.signatures.first
    answer = petition.updates.where(show_on_petition: true).first
    PetitionMailer.inform_user_of_answer_mail(signature, petition, answer)
  end

  def answer_due_date_request_mail
    PetitionMailer.answer_due_date_request_mail(Petition.live.first)
  end

  def answer_request_mail
    PetitionMailer.answer_request_mail(Petition.live.first)
  end

  def adoption_request_signatory_mail
    PetitionMailer.adoption_request_signatory_mail(Signature.last.petition, Signature.last)
  end

  def adoption_result_signatories_mail
    PetitionMailer.adoption_result_signatories_mail(Petition.live.first)
  end

  def welcome_with_password_mail
    password = Devise.friendly_token.first(8)
    PetitionMailer.welcome_petitioner_mail(Petition.first, User.first, password)
  end

end
