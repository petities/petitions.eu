namespace :signature do
  desc 'Delete unconfirmed signatures older then 30 days'
  task delete_old_signatures: :environment do
    Rails.logger = ActiveSupport::Logger.new('log/deleted_sigs.log')

    old_signatures = NewSignature.where('created_at < ?', 3.weeks.ago)
                                 .where.not(last_reminder_sent_at: nil)

    size = old_signatures.size
    old_signatures.delete_all
    Rails.logger.debug("deleted #{size} signatures")
  end

  desc 'Send reminder to confirm signature'
  task send_reminder: :environment do
    Rails.logger = ActiveSupport::Logger.new('log/send_reminders.log')

    new_reminders = NewSignature
                    .where('created_at < ?', 7.days.ago)
                    .where(last_reminder_sent_at: nil).limit(100)

    Rails.logger.debug("new_reminders #{new_reminders.size}")
    # send the first reminder
    new_reminders.find_each do |new_signature|
      Rails.logger.debug new_signature.person_email
      new_signature.send_reminder_mail
    end
  end
end
