# == Schema Information
#
# Table name: new_signatures
#
#  id                          :integer          not null, primary key
#  petition_id                 :integer          default(0), not null
#  person_name                 :string(255)
#  person_street               :string(255)
#  person_street_number_suffix :string(255)
#  person_street_number        :string(255)
#  person_postalcode           :string(255)
#  person_function             :string(255)
#  person_email                :string(255)
#  person_dutch_citizen        :boolean
#  signed_at                   :datetime
#  confirmed_at                :datetime
#  confirmed                   :boolean          default(FALSE), not null
#  unique_key                  :string(255)
#  special                     :boolean
#  person_city                 :string(255)
#  subscribe                   :boolean          default(FALSE)
#  person_birth_date           :string(255)
#  person_birth_city           :string(255)
#  sort_order                  :integer          default(0), not null
#  signature_remote_addr       :string(255)
#  signature_remote_browser    :string(255)
#  confirmation_remote_addr    :string(255)
#  confirmation_remote_browser :string(255)
#  more_information            :boolean          default(FALSE), not null
#  visible                     :boolean          default(FALSE)
#  created_at                  :datetime
#  updated_at                  :datetime
#  person_born_at              :date
#  reminders_sent              :integer
#  last_reminder_sent_at       :datetime
#  unconverted_person_born_at  :date
#  person_birth_country        :string(2)
#  person_country              :string(2)
#

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
