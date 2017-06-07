# == Schema Information
#
# Table name: task_statuses
#
#  id          :integer          not null, primary key
#  task_name   :string(255)
#  petition_id :integer
#  message     :string(255)
#  count       :integer          default(0)
#  last_action :datetime
#  created_at  :datetime
#  updated_at  :datetime
#

# Keep track of petition tasks  and emails send etc etc.
class TaskStatus < ActiveRecord::Base
  # is it time to execute task?
  def should_execute?(time_ago, max_count)
    # do we already hit our max?
    return false if count > max_count

    # did we already run to many times?
    return false if last_action && last_action > time_ago

    # add the count
    self.count += 1
    # save the last action date
    self.last_action = Time.zone.now
    save
  end
end
