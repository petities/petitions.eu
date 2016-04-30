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
#  person_country              :string(2)

class NewSignature < Signature
  self.table_name = 'new_signatures'

  before_save :fill_confirmed_at
  before_create :fill_signed_at
  after_create :send_confirmation_mail

  validates :person_email, uniqueness: { scope: :petition_id }

  def send_reminder_mail
    # Do not send reminders if the petition was deleted
    return unless petition

    return if destroy_if_already_confirmed || destroy_if_invalid
    send_reminder_mail!
  end

  private

  def destroy_if_already_confirmed
    confirmed_signatures = Signature.where(
      person_email: person_email, petition_id: petition_id
    )
    if confirmed_signatures.any?
      Rails.logger.debug "DESTROYED NewSignature #{id} for #{person_email} " \
                         "because confirmed_signatures exist"
      destroy
    end
  end

  def destroy_if_invalid
    unless valid?
      Rails.logger.debug "DESTROYED NewSignature #{id} for #{person_email} " \
                         "because it fails validation"
      destroy
    end
  end

  # increment reminders_sent value, update the time and send the message
  def send_reminder_mail!
    self.reminders_sent = reminders_sent.to_i + 1
    self.last_reminder_sent_at = Time.now.utc
    SignatureMailer.sig_reminder_confirm_mail(self).deliver_later if save
  end
end
