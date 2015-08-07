class AddTranslationsToFaq < ActiveRecord::Migration
  def up
    Faq.create_translation_table!
  end

  def down
    Faq.drop_translation_table!
  end
end
