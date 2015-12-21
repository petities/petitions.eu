# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#

#every 2.hours do
#  #command "/usr/bin/some_great_command"
#  #runner "MyModel.some_method"
#  #rake "some:great:rake:task"
#  rake new_signatures:send_reminder
#end



# Periodic tasks
################################################
#
#http://handboek.petities.nl/wiki/Periodic_tasks

#  orphan task
#82 office response about answer for petition.
#81 publish answer.
#80 get answer task
#79 petition get official reference number
#78 petition to process task

# Signature maintenance

every 10.minutes do
  # remove unconfirmed garbadge
  rake "signature:delete_old_signatures"
end

every 10.minutes do
  # send a reminder to confirm petition
  rake "signature:send_reminder"
end

every 30.minutes do
  # send a reminder to confirm petition
  rake "petition:publish_news_to_subscribers"
end

every :day, at: '1am' do
  # send a reminder to confirm petition
  rake "petition:publish_answer_to_subscribers"
end


# Petition maintenance

every 8.hours do
  rake "petition:handle_overdue_petitions"
end


every :day, at: '4am' do
  rake "petition:send_warning_due_date"
end

every :day, at:  '3am' do
  rake "petition:get_reference"
end

every :day, at: '2am' do
  #rake petition:send_answers
  rake "petition:get_reference"
end

every 12.hours do
  rake "petition:get_answer_from_office"
end


#every 4.days do
#   runner "AnotherModel.prune_old_records"
#end

# Learn more: http://github.com/javan/whenever
