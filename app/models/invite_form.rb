class InviteForm
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :mail, :signature

  validates :mail, email: true
  validates :signature, presence: true

  def deliver
    SignatureMailer.share_mail(signature, mail).deliver_later if valid?
  end
end
