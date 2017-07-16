class FillUpdatesDateFieldWithCreatedAt < ActiveRecord::Migration
  def change
    Update.where(date: nil).update_all('date = created_at')
  end
end
