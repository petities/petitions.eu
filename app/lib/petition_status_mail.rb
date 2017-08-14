# Builds list of recipients for PetitionMailer.status_change_mail
class PetitionStatusMail
  def initialize(petition)
    @petition = petition
  end

  def call
    recipients.each do |recipient|
      PetitionMailer.status_change_mail(petition, recipient).deliver_later
    end
  end

  def recipients
    [
      petitioner,
      users,
      office,
      Office.default_office.email
    ].flatten.uniq.reject(&:blank?)
  end

  private

  attr_reader :petition

  def petitioner
    petition.petitioner_email
  end

  def users
    petition.users.collect(&:email)
  end

  def office
    petition.office.email if petition.office.present?
  end
end
