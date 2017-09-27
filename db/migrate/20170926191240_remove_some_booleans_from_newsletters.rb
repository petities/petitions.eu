class RemoveSomeBooleansFromNewsletters < ActiveRecord::Migration
  def up
    remove_column :newsletters, :creating_messages
    remove_column :newsletters, :messages_created
    rename_column :newsletters, :number_of_messages_created, :messages_count
    remove_index :newsletters, :publish_from
    remove_column :newsletters, :publish_from
  end
end
