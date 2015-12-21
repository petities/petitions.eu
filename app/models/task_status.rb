# == Schema Information
#
# Table name: task_statuses
#
#  id          :integer          not null, primary key
#  task_name   :string(255)
#  petition_id :integer
#  message     :string(255)
#  count       :integer
#  last_action :datetime
#  created_at  :datetime
#  updated_at  :datetime
#

# Keep track of petition tasks
# and emails send etc etc.
#
#

class TaskStatus < ActiveRecord::Base


  # is it time to execute task?
  def should_execute?(time_ago, max_count)

    # do we already hit our max?
    if self.count > max_count
      return false
    end

    # did we already run to many times?
    if self.last_action && self.last_action > time_ago
      return false
    end

    # add the count
    self.count += 1
    # save the last laction date
    self.last_action = Time.now
    self.save
    return true
  end

end
