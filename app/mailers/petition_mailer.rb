class PetitionMailer < ApplicationMailer

  # 
  def status_change_mail(petition)
    @petition = petition
    
    subject = t('Petition.status.changed')

    if @petition.petitioner_email
      mail(to: @petition.petitioner_email, subject: subject )
    end
  end

  # finalize email 
  def finalize_mail(petition)

    @petition = petition

    subject = t('petition.moderation.pending')

    mail(to: @petition.office.email, subject: subject)

  end

  # petition is sending a subject
  def warning_due_date_mail(petition)

    subject = t('petition.is.due')

    mail(to: target, subject: subject)
  end

  # petition should get an answer
  def due_date_ask_for_answer(petition)

    subject = t('petition.office.please_answer')

    @petition = petition

    mail(to: @petition.office.email, subject: subject)
  end

end
