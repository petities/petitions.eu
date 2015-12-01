namespace :petition_due_date do

  desc 'Send warning of expiring due date'
  task :send_warning_due_date => :environment do

    Rails.logger = ActiveSupport::Logger.new('log/send_petition_due_date_warning.log')

    almost_petitions = Petition.
      where('due_date < ?', 7.days.from_now)
      where('due_date > ?', 6.days.from_now)
      where(status: :live)

    almost_petitions.each do |petition|
      if almost_petitions.signatures.confirmed.size < 10 
        PetitionMailer.warning_due_date_mail(petition)
      end
    end
  end

  desc 'Clear failed petitions with less then 10 signatures'
  task :clear_failed_petitions => :environment do
    Rails.logger = ActiveSupport::Logger.new('log/clear_failed_petition.log')
    overdue_petitions = Petition.
      where('due_date < ?', Time.now).
      where(status: :live)

    overdue_petitions.each do |petition|
      if almost_petitions.signatures.confirmed.size < 10 
        Rails.logger.debug('withdrawen %s %s' % [petition.id, petition.name])
        petition.status == 'withdrawn'
        petition.save
      end
    end


  end

  desc 'Ask for anser on Petition. due date has passed'
  task :ask_for_answer => :environment do
    Rails.logger = ActiveSupport::Logger.new('log/ask_for_answer.log')

  end

  ### handover

end
