require 'test_helper'

class UpdateTest < ActiveSupport::TestCase
  test 'date should be filled' do
    update = Update.new
    assert update.save
    assert_equal update.date, Time.zone.today
  end
end
