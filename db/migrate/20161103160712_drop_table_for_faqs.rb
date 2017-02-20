class DropTableForFaqs < ActiveRecord::Migration
  def up
    drop_table :faq_translations
    drop_table :faqs
  end
end
