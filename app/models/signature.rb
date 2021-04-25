class Signature < ApplicationRecord
  include StripWhitespace
  strip_whitespace :person_city, :person_email, :person_function, :person_name, :person_street_number

  include TruncateString
  truncate_string :signature_remote_browser, :confirmation_remote_browser

  belongs_to :petition
  has_one :pledge, autosave: false, dependent: :destroy

  has_secure_token :unique_key

  validates :person_name, length: { in: 3..255 }
  validates :person_name, format: { with: /\A.+( |\.).+\z/ }
  validates :person_email, email: true
  validates :person_email, uniqueness: { scope: :petition_id }

  # FIXME
  # def country_postalcode_validation
  #  case I18n.locale
  #    when :en
  #      # check for latin characters
  #      return true
  #    when :de
  #      return true
  #      # check for cyrillic characters
  #    when :nl
  #      return true
  #    return true
  #  end
  #  return true
  # end

  # Some petitions require a full address
  # validates :person_postalcode,
  #          #format: { with: /\A[1-9]{1}\d{3} ?[A-Z]{2}\z/ },
  #          on: :update,
  #          if: :require_full_address?

  validates :person_city,
            length: { maximum: 255 },
            allow_blank: true,
            unless: :require_full_address?

  validates :person_function, length: { maximum: 255 }, allow_blank: true

  with_options if: :require_full_address?, on: :update do |full_address|
    full_address.validates :person_city, length: { in: 3..255 }
    full_address.validates :person_street, length: { in: 3..255 }
    full_address.validates :person_street_number, numericality: { only_integer: true }
    full_address.validates :person_street_number_suffix,
                           length: { in: 1..255 }, allow_blank: true
  end

  validates_date :person_born_at,
                 on_or_before: :required_minimum_age,
                 on: :update,
                 if: :require_minimum_age?

  validates_date :person_born_at,
                 on: :update,
                 if: :require_born_at?

  validates :person_birth_city,
            length: { in: 3..255 },
            on: :update,
            if: :require_person_city?

  scope :confirmed, -> { where(confirmed: true) }
  scope :hidden, -> { where(visible: false) }
  scope :subscribe, -> { where(confirmed: true, subscribe: true) }
  scope :special, -> { where(confirmed: true, special: true) }
  scope :visible, -> { where(visible: true, confirmed: true) }
  scope :ordered, -> { order(special: :desc, confirmed_at: :desc) }

  before_validation :lowercase_person_email
  before_save :fill_confirmed_at, :set_sort_order
  before_create :fill_signed_at

  after_save :update_petition

  def update_petition
    # no more hit/edit/save on petition! YAY
    set_redis_keys if confirmed_changed?
  end

  def set_redis_keys(task = false)
    redis = Redis.current

    # last updates
    if confirmed_at
      key = "p-last-#{petition.id}"
      last = Time.zone.at(redis.get(key).to_i)
      redis.set(key, confirmed_at.to_i) if confirmed_at > last
    end

    # keep track of signature counts the last hours
    if confirmed_at > 1.day.ago
      hour_key = "p-h-#{petition.id}-#{confirmed_at.year}-#{confirmed_at.month}-#{confirmed_at.day}-#{confirmed_at.hour}"
      redis.incr(hour_key)
      # forget hour keys after 24 hours
      redis.expire(hour_key, 1.day)
    end

    unless task
      redis.incr("p-d-#{petition.id}-#{confirmed_at.year}-#{confirmed_at.month}-#{confirmed_at.day}")
      # size rating
      redis.zincrby('petition_size', 1, petition.id)
      # size count
      if petition.is_live?
        counter = RedisPetitionCounter.new(petition)
        counter.update(petition.signatures_count) unless counter.exists?
        counter.increment
      end
      # activity rating
      petition.update_active_rate!
    end
  end

  def require_full_address?
    active_petition_type&.require_signature_full_address?
  end

  def require_born_at?
    active_petition_type&.require_person_born_at?
  end

  def require_minimum_age?
    active_petition_type&.required_minimum_age.present?
  end

  def require_person_city?
    active_petition_type&.require_person_birth_city?
  end

  def require_person_country?
    active_petition_type&.country_code.present?
  end

  # ActiveAdmin tries .name for display in lists.
  def name
    person_name
  end

  def similars
    @similars ||= self.class.where.not(id: id).where(person_email: person_email)
  end

  def new_signatures
    @new_signatures ||= NewSignature.where(person_email: person_email)
  end

  private

  def lowercase_person_email
    self.person_email = person_email.to_s.downcase
  end

  def send_confirmation_mail
    if last_reminder_sent_at.nil?
      SignatureMailer.sig_confirmation_mail(self).deliver_later
    end
    true
  end

  def fill_confirmed_at
    self.confirmed_at = Time.zone.now if confirmed_at.nil? && confirmed?
  end

  def fill_signed_at
    self.signed_at = Time.zone.now if signed_at.nil?
  end

  def set_sort_order
    self.sort_order = 0 if sort_order.blank?
  end

  def active_petition_type
    petition.active_petition_type
  end
end
