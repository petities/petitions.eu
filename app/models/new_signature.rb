class NewSignature < Signature
  self.table_name  = 'new_signatures'

  before_save :generate_unique_key, :fill_confirmed_at
  before_create :fill_signed_at
  after_save :send_confirmation_mail

  validates_uniqueness_of :person_email, scope: :petition_id

  protected

  def send_confirmation_mail
    # puts 'sending mail???'
    SignatureMailer.sig_confirmation_mail(self).deliver_later
    true
  end

  def generate_unique_key
    self.unique_key = SecureRandom.urlsafe_base64(16) if unique_key.nil?
    true
  end

  def fill_confirmed_at
    self.confirmed_at = Time.now.utc if confirmed_at.nil? && self.confirmed?
    true
  end

  def fill_signed_at
    self.signed_at = Time.now.utc if signed_at.nil?
    true
  end

  def update_petition
    petition.last_confirmed_at = Time.now.utc if self.confirmed?
    petition.save
    true
  end
end
