namespace :signature do
  desc 'Delete unconfirmed signatures older then 30 days'
  task delete_old_signatures: :environment do
    Rails.logger = ActiveSupport::Logger.new('log/deleted_sigs.log')

    old_signatures = NewSignature.where('created_at < ?', 30.days.ago)
                                 .where.not(last_reminder_sent_at: nil)

    size = old_signatures.size
    old_signatures.delete_all
    Rails.logger.debug("deleted #{size} signatures")
  end

  desc 'fix migration signatures..'
  task migrate_signatures: :environment do
    migrate = Signature
      .where('created_at < ?', Time.new(2015, 12, 28))
      .where(confirmed: false)
      #.where(last_reminder_sent_at: nil).limit(100)

    migrate.each do |signature|
      puts "%s %s %s" % [
        signature.petition_id,
        signature.person_name,
        signature.person_email
      ]
    end
  end

  desc 'fix office admins..'
  task fix_office_admin: :environment do

    user = User.find_by_email('reinder@rustema.nl')
    Office.all.each do |office|
      user.add_role(:admin, office)
    end

  end

  desc 'fix migration signatures..28-12-2015'
  task migrate_signatures: :environment do
    migrate = Signature
      .where('created_at > ?', Time.new(2015, 12, 28))
      .where(confirmed: false)

    puts migrate.count

    migrate.each do |signature|
      old_signature = signature
      # create a new signature in the signarure table.
      signature = NewSignature.new(
      old_signature.attributes.select{ |key, _| NewSignature.attribute_names.include? key })
      signature.save
      old_signature.delete

      puts "MOVED %s %s %s %s" % [
        signature.petition_id,
        signature.created_at,
        signature.person_name,
        signature.person_email
      ]

    end
  end

  desc 'Send reminder to confirm signature'
  task send_reminder: :environment do
    Rails.logger = ActiveSupport::Logger.new('log/send_reminders.log')

    #old_reminder = NewSignature
    #               .where('last_reminder_sent_at < ?', 2.days.ago)
    #               .where('reminders_sent < ?', 3).limit(100)

    new_reminders = NewSignature
                    .where('created_at < ?', 7.days.ago)
                    .where(last_reminder_sent_at: nil).limit(100)

    #Rails.logger.debug('old_reminders %s' % old_reminder.size)
    ## send new reminder
    #old_reminder.each do |new_signature|
    #  new_signature.send(:send_reminder_mail)
    #end

    Rails.logger.debug("new_reminders #{new_reminders.size}")
    # send the first reminder
    new_reminders.find_each do |new_signature|
      Rails.logger.debug new_signature.person_email
      new_signature.send_reminder_mail
    end
  end
end
