namespace :signature do

  desc 'Delete unconfirmed signatures older then a week'
  task :delete_old_signatures => :environment do
    Rails.logger = ActiveSupport::Logger.new('log/deleted_sigs.log')

    invalid = NewSignature.where('created_at < ?', 10.days.ago)
    size = invalid.size
    invalid.delete_all
    Rails.logger.debug('deleted %s signatures' % size)
  end

  desc 'Send reminder to confirm signature'
  task :send_reminder => :environment do
    Rails.logger = ActiveSupport::Logger.new('log/send_reminders.log')

    old_reminder = NewSignature.
      where('last_reminder_sent_at < ?', 2.days.ago).
      where('reminders_sent < ?', 3).limit(100)

    new_reminder = NewSignature.
      where('created_at < ?', 2.days.ago).
      where(last_reminder_sent_at: nil).limit(100)

    Rails.logger.debug('old_reminders %s' % old_reminder.size)
    # send new reminder
    old_reminder.each do |new_signature|
      new_signature.send(:send_reminder_mail)
    end

    Rails.logger.debug('new_reminders %s' % new_reminder.size)
    # send the first reminder
    new_reminder.each do |new_signature|
      new_signature.send(:send_reminder_mail)
    end

  end

end
