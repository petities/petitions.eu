class AddperiodicTaskStatus < ActiveRecord::Migration
  def up
    create_table 'task_statuses' do |t|
      t.string 'task_name'
      t.integer 'petition_id'
      t.string 'message'
      t.integer 'count', default: 0
      t.datetime 'last_action'
      t.datetime 'created_at'
      t.datetime 'updated_at'
    end
  end

  def down
    drop_table 'task_statuses'
  end
end
