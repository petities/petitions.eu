class RemoveSomeOldTables < ActiveRecord::Migration
  def change
    drop_table :admin_comments
    drop_table :delayed_jobs
    drop_table :feedbacks
    drop_table :initiations
    drop_table :pages
    drop_table :statistics
    drop_table :tolk_locales
    drop_table :tolk_phrases
    drop_table :tolk_translations
  end
end
