# == Schema Information
#
# Table name: signatures
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
#  person_country              :string(2)
#

class Signature < ActiveRecord::Base
  belongs_to :petition
  has_one :petition_type, through: :petition

  has_secure_token :unique_key

  # has_many :reminders, :class_name => 'SignaturesReminder'
  # has_many :reconfirmations, :class_name => 'SignaturesReconfirmation'

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
            length: { in: 3..255 },
            on: :update,
            if: :require_full_address?

  validates :person_street,
            length: { in: 3..255 },
            on: :update,
            if: :require_full_address?

  validates :person_street_number,
            numericality: { only_integer: true },
            on: :update,
            if: :require_full_address?

  validates :person_street_number_suffix,
            length: { in: 1..255 },
            allow_blank: true,
            on: :update,
            if: :require_full_address?

  validates_date :person_born_at,
                 on_or_before: :required_minimum_age,
                 on: :update,
                 if: :require_minimum_age?

  validates :person_birth_city,
            length: { in: 3..255 },
            on: :update,
            if: :require_person_city?

  scope :confirmed, -> { where(confirmed: true) }
  scope :hidden, -> { where(visible: false) }
  scope :subscribe, -> { where(confirmed: true, subscribe: true) }
  scope :special, -> { where(special: true, confirmed: true) }
  scope :visible, -> { where(visible: true, confirmed: true) }

  before_validation :strip_whitespace, :lowercase_person_email
  before_save :fill_confirmed_at
  before_create :fill_signed_at

  after_save :update_petition

  def update_petition

    self.set_redis_counts

    if self.confirmed_changed?
      petition.last_confirmed_at = Time.now.utc
      petition.signatures_count += 1
      petition.update_active_rate!
      petition.save
    end

  end

  def set_redis_counts

    if self.confirmed_changed?
      t = created_at

      #petition.last_confirmed_at = Time.now.utc
      #petition.last_confirmed_at = Time.now.utc
      $redis.incr('p%s-last-' % [petition.id, t.to_i])

      $redis.incr('p%s-count' % petition.id)

      $redis.incr('p%s-%s-count' % [
        petition.id, t.year])

      $redis.incr('p%s-%s-%s-count' % [
        petition.id, t.year, t.month])

      $redis.incr('p%s-%s-%s-%s-count' % [
        petition.id, t.year, t.month, t.day])

      $redis.incr('p%s-%s-%s-%s-count' % [
        petition.id, t.year, t.month, t.day, t.hour])

    end
  end

  def require_full_address?
    petition_type.present? && petition_type.require_signature_full_address?
  end

  def require_born_at?
    petition_type.present? && petition_type.require_person_born_at?
  end

  def require_minimum_age?
    petition_type.present? && petition_type.required_minimum_age.present?
  end

  def require_person_city?
    petition_type.present? && petition_type.require_person_birth_city?
  end

  def require_person_country?
    petition_type.present? && petition_type.country_code.present?
  end

  private

  def strip_whitespace
    self.person_street_number = person_street_number.strip unless person_street_number.nil?
    self.person_name = person_name.strip unless person_name.nil?
    self.person_email = person_email.strip unless person_email.nil?
  end

  def lowercase_person_email
    self.person_email = person_email.to_s.downcase
  end

  def send_confirmation_mail
    # puts 'sending mail???'
    SignatureMailer.sig_confirmation_mail(self).deliver_later
    true
  end

  def send_reminder_mail

    SignatureMailer.sig_reminder_confirm_mail(self).deliver_later

    # update the time
    self.last_reminder_sent_at = Time.now

    # update the reminder sent value
    if reminders_sent.nil?
      self.reminders_sent = 1
    else
      self.reminders_sent = reminders_sent + 1
    end

    # save the resulting sig
    self.save
    Rails.logger.debug 'reminder email to %s' % person_email
    #destroy
    #end
  end

  def fill_confirmed_at
    self.confirmed_at = Time.now.utc if confirmed_at.nil? && self.confirmed?
  end

  def fill_signed_at
    self.signed_at = Time.now.utc if signed_at.nil?
  end
end
