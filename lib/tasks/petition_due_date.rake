namespace :petition_due_date do

  desc 'Send warning of expiring due date'
  task :send_warning_due_date => :environment do

    Rails.logger = ActiveSupport::Logger.new('log/send_petition_due_date_warning.log')

    almost_petitions = Petition.
      where('date_projected < ?', 7.days.from_now).
      where('date_projected > ?', 6.days.from_now).
      where(status: :live).limit(100)

    Rails.logger.debug('due date warnings %s' % almost_petitions.size)

    almost_petitions.each do |petition|
      if almost_petitions.signatures.confirmed.size < 10 
        PetitionMailer.warning_due_date_mail(petition)
      end
    end
  end

  desc 'handle over due petitions'
  task :handle_overdue_petitions => :environment do
    Rails.logger = ActiveSupport::Logger.new('log/clear_failed_petition.log')
    overdue_petitions = Petition.
      where('due_date < ?', Time.now).
      where(status: :live).limit(100)

    overdue_petitions.each do |petition|
      if petition.signatures.confirmed.size < 10 
        Rails.logger.debug('withdrawn %s %s' % [petition.id, petition.name])
        petition.status == 'withdrawn'
        petition.save
      elsif petition.updates.size < 1 
        # change status to orphan
        petition.status == 'orphan'
        Rails.logger.debug('orphan %s %s' % [petition.id, petition.name])

      else
        Rails.logger.debug('request answer %s %s' % [petition.id, petition.name])
        # send request to answer to office
        # change status to to_process
        #
      end
    end
  end

end
