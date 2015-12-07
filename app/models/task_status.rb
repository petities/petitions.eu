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

end
