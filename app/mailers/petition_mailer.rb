class PetitionMailer < ApplicationMailer

  def status_change_mail(petition)
    @petition = petition

    if @petition.petitioner_email
      mail(to: @petition.petitioner_email, subject: 'Petition status changed')
    end
  end

  def finalize_mail(petition)
    @petition = petition

    mail(to: 'website@petities.nl', subject: 'Petition moderation pending')
  end

  # #72
  # withdraw any petition with less then 10 signatures
  # more
  def warning_due_date_mail(petition)

  end

  # petition should get an answer
  def due_date_ask_for_answer(petition)

  end

end
