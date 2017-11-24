namespace :petition do
  desc 'fix signature counts'
  task fix_signature_counts: :environment do
    Petition.live.find_each do |petition|
      count = petition.signatures.count
      old_count = petition.signatures_count

      next if count == old_count

      puts [count, old_count, petition.name].join(' - ')

      petition.signatures_count = count

      puts "Error saving #{petition.name}" unless petition.save

      RedisPetitionCounter.new(petition).update_with_limit(count)
    end
  end

  desc 'create redis signature CITY counts'
  task set_redis_city_counts: :environment do
    def city_counts(petition)
      @signatures_count_by_city = petition.signatures.group_by(&:person_city)
                                  .map { |group| [group[0], group[1].size] }
                                  .select { |group| group[1] >= 20 }
                                  .sort_by { |group| group[1] }
    end

    r = Redis.new

    Petition.live.find_each do |petition|
      r.del("p#{petition.id}_city")

      city_counts(petition).each do |group|
        city_name = group[0].downcase
        count = group[1].to_i
        r.zincrby("p#{petition.id}_city", count, city_name)
      end
    end
  end

  desc 'create redis summary graph'
  task create_redis_month_counts: :environment do
    # Petition.where(status: false).each_with_index do |petition, index|
    #
    # end
  end


  desc 'create redis signature counts'
  task set_redis_signature_counts: :environment do
    require 'benchmark'

    def delete_all
      r = Redis.new

      # delete old rankings
      r.del('petition_size')
      r.del('active_rate')

      # delete all petition related keys
      keys = r.keys('p*')
      puts "Delete old keys #{keys.size}"

      r.del(*keys) if keys.size > 0
    end

    #delete_all
    #
    Petition.live.find_each do |petition|

      count = petition.signatures.confirmed.count

      next if petition.name.blank?

      puts '%5s - %6s - %s' % [
        petition.id, count, petition.name]

      # general count
      RedisPetitionCounter.new(petition).update(count)
      # Main rankings
      $redis.zrem('petition_size', petition.id)
      $redis.zadd('petition_size', count, petition.id)

      # last hours activity rate
      puts
      puts Benchmark.measure {
        petition.create_hour_keys
      }

      # day barchart keys for graph
      puts
      puts Benchmark.measure {
        petition.delete_keys
        petition.create_raw_sql_barchart_keys
      }
      # call this only once!
      puts "Active rate: #{petition.update_active_rate!}"
    end
    # clear the cache
    Rails.cache.clear
  end

  desc 'Send warning of expiring due date'
  task send_warning_due_date: :environment do
    Rails.logger = ActiveSupport::Logger.new(
      'log/send_petition_due_date_warning.log'
    )

    almost_petitions = Petition.where('date_projected < ?', 7.days.from_now)
                               .where('date_projected > ?', 6.days.from_now)
                               .where(status: :live).limit(100)

    Rails.logger.debug("due date warnings #{almost_petitions.size}")

    almost_petitions.find_each do |petition|
      if almost_petitions.signatures.confirmed.size < 10
        PetitionMailer.due_next_week_warning_mail(petition).deliver_later
      end
    end
  end

  desc 'handle over due petitions'
  task handle_overdue_petitions: :environment do
    Rails.logger = ActiveSupport::Logger.new('log/clear_failed_petition.log')
    overdue_petitions = Petition.where('date_projected < ?', Time.now)
                                .where(status: :live).limit(100)

    overdue_petitions.find_each do |petition|
      if petition.signatures.size < 10
        Rails.logger.debug("withdrawn #{petition.id} #{petition.name}")
        petition.status = 'withdrawn'
      elsif petition.updates.size < 1
        # change status to orphan
        petition.status = 'orphan'
        Rails.logger.debug("orphaned #{petition.id} #{petition.name}")
      else
        Rails.logger.debug("request answer due date #{petition.id} #{petition.name}")
        # send request for answer due date to office
        # change status to to_process
        petition.status = 'to_process'
        PetitionMailer.ask_office_answer_due_date_mail(petition).deliver_later
      end
      petition.save
    end
  end

  desc 'help find new owners for orphan petitions'
  task find_new_owner: :environment do
    Rails.logger = ActiveSupport::Logger.new('log/find_new_owner.log')

    # find at most 100 orphans
    orphan_petitions = Petition
                       .where(status: :orphan).limit(100)

    orphan_petitions.each do |petition|
      task_status = TaskStatus.find_or_create_by(
        task_name: 'find_owner',
        petition_id: petition.id)

      if task_status.count
        # already launched a search before..
        if task_status.last_action < 7.days.ago
          # no owner found.
          petition.status = 'withdrawn'
          petition.save
          petition.email_answer(
            answer: t('petition.is.withdrawn', default: 'Petition is withdrawn'))
        end
        next
      end

      # find at most 100 candiates
      candidates = Pledge.where(petition_id: orphan.id)
                         .joins(:task_status)
                         .where(task_statuses: { inform_me: true }).limit(100)

      Rails.logger.debug(
        "found #{candidates.size} candidates for #{petition.name}"
      )

      # email each candiate to be admin
      candidates.each do |candidate|
        PetitionMailer.adoption_request_signatory_mail(petition, candidate.signature).deliver_later
      end
    end
  end

  desc 'Get reference number'
  task get_reference_number: :environment do
    Rails.logger = ActiveSupport::Logger.new('log/get_reference_number.log')

    missing_reference_number = Petition
                               .where('date_projected < ?', Time.now)
                               .where(reference_field: nil)
                               .where(status: :to_process).limit(110)

    Rails.logger.debug(missing_reference_number.size)

    missing_reference_number.each do |petition|
      # find task or create
      task_status = TaskStatus.find_or_create_by(
        task_name: 'get_reference_number',
        petition_id: petition.id)

      next unless task_status.should_execute?(7.days.ago, 3)
      PetitionMailer.reference_number_mail(petition).deliver_later
      Rails.logger.debug('sending reference mail.')
      task_status.count += 1
      task_status.save
      # save the current task status
    end
  end

  desc 'Get answer for petition from office'
  task get_answer_from_office: :environment do
    Rails.logger = ActiveSupport::Logger.new('log/get_answer.log')

    # find all petitions that not have an answer yet
    need_answers = Petition.where(status: 'in_process')
                           .where('date_projected < ?', Time.now)
                           .joins(:updates)
                           .where(newsitems: { show_on_petition: [nil, false] })
                           .limit(100)

    Rails.logger.debug(need_answers.size)

    need_answers.each do |petition|
      task_status = TaskStatus.find_or_create_by(
        task_name: 'get_answer',
        petition_id: petition.id)

      next unless task_status.should_execute(7.days.ago, 3)
      task_status.count += 1
      task_status.last_action = Time.now
      PetitionMailer.ask_office_for_answer_mail(petition).deliver_later
      Rails.logger.debug(
        'asked %s x %s for answer on %s' % [
          petition.office.name,
          task_status.count,
          petition.name])

      task_status.save
    end
  end

  desc 'publish news to subscribers'
  task publish_news_to_subscribers: :environment do
    Rails.logger = ActiveSupport::Logger.new('log/publish_news.log')

    has_news = Petition.where(status: 'live')
                       .joins(:updates)
                       .where('newsitems.created_at > ?', 1.day.ago).limit(10)

    has_news.each do |petition|
      publish_task = TaskStatus.find_or_create_by(
        task_name: 'publish_news',
        petition_id: petition.id)

      unless publish_task.should_execute?(2.days.ago, 3)
        # skip
        # publish_task.update(count: 0 ,last_action: 3.days.ago)
        # publish_task.save
        Rails.logger.debug('we only publish 3 times')
        Rails.logger.debug("and at most and once a day #{petition.name}")
        next
      end

      # find all people that want to be informed
      inform_me = Signature
                  .where(petition_id: petition.id)
                  .where(subscribe: true)

      message = "#{inform_me.size} people get newsupdate on #{petition.name}"
      Rails.logger.debug(message)
      publish_task.message = message

      # find the answer
      news_update = petition.updates.first

      # inform each pledged user of answer
      inform_me.find_each do |signature|
        SignatureMailer.inform_user_of_news_update_mail(
          signature, news_update
        ).deliver_later
      end
      # store progress
      publish_task.save
    end
  end

  desc 'publish answer to interested people'
  task publish_answer_to_subscribers: :environment do
    Rails.logger = ActiveSupport::Logger.new('log/publish_answer.log')

    # find all petitions with an answer and are not completed
    have_answer = Petition.where(status: 'in_process')
                          .where('answer_due_date < ?', Time.now)
                          .joins(:updates)
                          .where(newsitems: { show_on_petition: true })
                          .limit(10)

    # find users that want to know about the answer
    have_answer.find_each do |petition|
      publish_task = TaskStatus.find_or_create_by(
        task_name: 'publish_answer',
        petition_id: petition.id)

      unless publish_task.should_execute?(nil, 1)
        # skip
        Rails.logger.debug("we only publish once #{petition.name}")
        next
      end

      # find all people that want to be informed
      # inform_me = Pledge
      #             .where(petition_id: petition.id)
      #             .where(inform_me: true)

      message = "#{inform_me.size} people want answer on #{petition.name}"
      Rails.logger.debug(message)
      publish_task.message = message

      # find the answer
      answer = petition.updates.where(show_on_petition: true).first

      # inform each pledged user of answer
      inform_me.each do |pledge|
        SignatureMailer.inform_user_of_answer_mail(
          pledge.signature, answer
        ).deliver_later
      end

      # set petition status on completed
      petition.status = 'completed'
      Rails.logger.debug("completed publish #{petition.name}")
      petition.save
      publish_task.save
    end
  end

  desc 'update slugs from petition name'
  task update_slugs: :environment do
    Petition.find_each do |p|
      # NOTE maybe put true
      # Petition.should_generate_new_friendly_id?
      p.update(name: p.name) if p.slug.blank?
      puts p.friendly_id
    end
  end
end
