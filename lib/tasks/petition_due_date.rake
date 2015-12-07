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
      where('date_projected < ?', Time.now).
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

  desc 'Get reference number'
  task :get_reference_number => :environment do
    Rails.logger = ActiveSupport::Logger.new('log/get_reference_number.log')
    missing_reference_number = Petition.
      where('date_projected < ?', Time.now).
      where(reference_field: nil).
      where(status: :to_process).limit(110)

    Rails.logger.debug(missing_reference_number.size)

    missing_reference_number.each do |petition|

      # find task or create
      task_status = TaskStatus.find_or_create_by(
        task_name: 'get_reference_number',
        petition_id: petition.id)

      if task_status.count.nil?
        task_status.count = 0
      end

      if task_status.last_action.nil?
        task_status.last_action = Time.now
        PetitionMailer.send_reference_number(petition)
        Rails.logger.debug('sending first mail.')
        task_status.count += 1
      elsif
        if task_status.count < 3
          if task_status.last_action < 7.days.ago
            task_status.last_action = Time.now
            PetitionMailer.send_reference_number(petition)
            Rails.logger.debug('sending %s mail..' % task_status.count)
          end
        end
      end
      # save the current task status
      # Rails.logger.debug('send %s mail.' % task_status.count)
      task_status.save
      # check if not already there.
    end
  end
end
