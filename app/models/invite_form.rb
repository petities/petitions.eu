class InviteForm
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
  include StripWhitespace
  include Transliterate

  attr_accessor :mail, :signature

  strip_whitespace :mail
  transliterate :mail
  validates :mail, email: true
  validates :signature, presence: true

  def deliver
    SignatureMailer.share_mail(signature, mail).deliver_later if valid?
  end
end
