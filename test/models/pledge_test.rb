# == Schema Information
#
# Table name: pledges
#
#  id           :integer          not null, primary key
#  influence    :string(255)
#  skill        :string(255)
#  money        :integer          default(0)
#  feedback     :string(255)
#  inform_me    :boolean
#  petition_id  :integer
#  signature_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class PledgeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
