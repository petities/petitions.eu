class NewSignature < Signature
  include Transliterate
  self.table_name = 'new_signatures'

  before_save :fill_confirmed_at
  before_create :fill_signed_at
  after_commit :send_confirmation_mail, on: :create

  transliterate :person_email
  validates :person_email, uniqueness: { scope: :petition_id }

  def send_reminder_mail
    # Do not send reminders if the petition was deleted
    return unless petition
    return if destroy_if_already_confirmed

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

  def send_reminder_mail!
    # increment counter and set last_reminder_sent_at without validations
    update_columns(
      reminders_sent: reminders_sent.to_i + 1,
      last_reminder_sent_at: Time.zone.now
    )
    SignatureReminderJob.perform_later(self).deliver_later
  end
end
