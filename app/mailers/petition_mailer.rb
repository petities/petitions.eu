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
end
