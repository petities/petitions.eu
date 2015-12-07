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

every 10.mins do
  rake new_signatures:send_reminder
end


every 8.hours do
  rake petition_due_date:send_warning_due_date
end


every 9.hours do
  rake petition_due_date:send_warning_due_date
end

every 11.hours do
  rake petition_due_date:get_reference
end



#every 4.days do
#   runner "AnotherModel.prune_old_records"
#end

# Learn more: http://github.com/javan/whenever
