# Preview all emails at http://localhost:3000/rails/mailers/petition_mailer
class PetitionMailerPreview < ActionMailer::Preview

  def status_change
    PetitionMailer.status_change_mail(Petition.live.first)
  end

  def finalize_mail
    PetitionMailer.finalize_mail(Petition.live.first)
  end
 
  def warning_due_date_mail
    PetitionMailer.warning_due_date_mail(Petition.live.first)
  end

  def due_date_ask_for_answer
    PetitionMailer.due_date_ask_for_answer(Petition.live.first)
  end
 
end
