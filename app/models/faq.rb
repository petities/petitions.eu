# == Schema Information
#
# Table name: faqs
#
#  id          :integer          not null, primary key
#  question    :string(255)
#  answer      :text(65535)
#  created_at  :datetime
#  updated_at  :datetime
#  cached_slug :string(255)
#  group       :string(255)
#

class Faq < ActiveRecord::Base
  self.table_name = 'faqs'

  translates :question, :answer
end
