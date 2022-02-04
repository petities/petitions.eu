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
    ids = NewSignature.where('created_at < ?', 2.days.ago)
                      .where(last_reminder_sent_at: nil).limit(100).pluck(:id)

    ids.each do |new_signature_id|
      new_signature = NewSignature.find(new_signature_id)
      new_signature.send_reminder_mail
    end
  end
end
