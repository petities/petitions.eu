class AddAnswerDateProjectedToPetitions < ActiveRecord::Migration
  def change
    add_column :petitions, :answer_due_date, :date
  end
end
