class NewSignature < Signature 
  self.table_name  = "new_signatures"

  before_save :generate_unique_key, :fill_confirmed_at
  before_create :fill_signed_at
  after_save :send_confirmation_mail

  protected

  def send_confirmation_mail
    # puts 'sending mail???'
    SignatureMailer.sig_confirmation_mail(self).deliver_later
    return true
  end

  def generate_unique_key
    self.unique_key = SecureRandom.urlsafe_base64(16) if self.unique_key.nil?
    return true
  end

  def fill_confirmed_at
    self.confirmed_at = Time.now.utc if self.confirmed_at.nil? && self.confirmed?
    return true
  end

  def fill_signed_at
    self.signed_at = Time.now.utc if self.signed_at.nil?
    return true
  end

  def update_petition
    self.petition.last_confirmed_at = Time.now.utc if self.confirmed?
    self.petition.save
    return true
  end
end
