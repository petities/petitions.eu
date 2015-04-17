

class Signature < ActiveRecord::Base

  belongs_to :petition #, :counter_cache => true
  has_one :petition_type, :through => :petition

  has_many :reminders, :class_name => 'SignaturesReminder'
  has_many :reconfirmations, :class_name => 'SignaturesReconfirmation'

  validates :person_name, length: {in: 3..255}
  validates :person_name, format: { with: /\A.+( |\.).+\z/}

  # keep this simple since we are sending validation emails anyways.
  validates :person_email, format: {with: /@/}
  #
  # Some petitions require a full address
  validates :person_postalcode, format: {with: /\A[1-9]{1}\d{3} ?[A-Z]{2}\z/, on: :update}, :if => :require_full_address?
  validates :person_city, length: {in: 3..255}, on: :update, if: :require_full_address?
  validates :person_street, length: {in: 3..255}, on: :update, if: :require_full_address?
  validates :person_street_number, numericality: {only_integer: true}, on: :update, if: :require_full_address?
  validates :person_street_number_suffix, length: {in: 1..255}, allow_blank: true, on: :update, if: :require_full_address?


  scope :confirmed, -> { where(confirmed: true) }
  scope :hidden, -> { where(visible: false) }
  scope :subscribe, -> { where(confirmed: true, subscribe: true) }
  scope :special, -> { where(special: true, confirmed: true) }
  scope :visible, -> { where(visible: true, confirmed: true) }


  before_save :generate_unique_key, :fill_confirmed_at
  before_create :fill_signed_at
  after_save :update_petition, :confirm_by_mail

  #define_index do
  #  has last_confirmed_at, :as => :last_confirmed_at, :sortable=>true
  #end

  protected

  def confirm_by_mail
    if not self.confirmed? 
      # if not created with an existing account.
      SignatureMailer.confirmation_signature(self)
    end
  end

  def generate_unique_key
    self.unique_key = SecureRandom.urlsafe_base64(16) if self.unique_key.nil?
  end

  def fill_confirmed_at
    self.confirmed_at = Time.now.utc if self.confirmed_at.nil? && self.confirmed?
  end

  def fill_signed_at
    self.signed_at = Time.now.utc if self.signed_at.nil?
  end

  def update_petition
    self.petition.last_confirmed_at = Time.now.utc if self.confirmed?
    self.petition.save
  end

  def require_full_address?
    return true if petition.present? && petition.petition_type.present? && petition.petition_type.require_signature_full_address?
    #return true if petition.present? && petition.office.present? && petition.office.petition_type.present? && petition.office.petition_type.require_signature_full_address?
  end

  def require_born_at?
    return true if petition.present? && petition.petition_type.present? && petition.petition_type.require_person_born_at?
    #return true if petition.present? && petition.office.present? && petition.office.petition_type.present? && petition.office.petition_type.require_person_born_at?
  end

  def require_minimum_age?
    return true if petition.present? && petition.petition_type.present? && petition.petition_type.required_minimum_age.present?
    #return true if petition.present? && petition.office.present? && petition.office.petition_type.present? && petition.office.petition_type.required_minimum_age.present?
  end

  def require_person_birth_city?
    return true if petition.present? && petition.petition_type.present? && petition.petition_type.require_person_birth_city?
    return true if petition.present? && petition.office.present? && petition.office.petition_type.present? && petition.office.petition_type.require_person_birth_city?
  end

end
