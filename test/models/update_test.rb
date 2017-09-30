require 'test_helper'

class UpdateTest < ActiveSupport::TestCase
  test 'date should be filled' do
    update = Update.new(title: 'This is a title', text: 'This is the body.')
    assert update.save
    assert_equal update.date, Time.zone.today
  end
end
