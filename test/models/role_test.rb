# == Schema Information
#
# Table name: roles
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  authorizable_type :string(255)
#  authorizable_id   :integer
#  created_at        :datetime
#  updated_at        :datetime
#  resource_type     :string(255)
#  resource_id       :integer
#

require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
