# Preview all emails at http://localhost:3000/rails/mailers/petition_mailer
class PetitionMailerPreview < ActionMailer::Preview

  def status_change
    PetitionMailer.status_change_mail(Petition.live.first)
  end

  def finalize_mail
    PetitionMailer.finalize_mail(Petition.live.first)
  end
end
