class ContactForm
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :name, :mail, :message

  validates :name, length: { in: 5..255 }
  validates :mail, email: true
  validates :message, presence: true

  def deliver
    ContactMailer.webmaster_message(self).deliver_now if valid?
  end
end
