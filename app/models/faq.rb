class Faq < ActiveRecord::Base
  self.table_name = 'faqs'

  translates :question, :answer
end
