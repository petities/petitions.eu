require 'test_helper'

class UpdateTest < ActiveSupport::TestCase
  test 'date should be filled' do
    update = Update.new(title: 'This is a title', text: 'This is the body.')
    assert update.save
    assert_equal update.date, Time.zone.today
  end

  test 'second update with the same title should have slug with date' do
    update = Update.create(title: 'This is a title', text: 'This is the body.', date: Date.yesterday)
    assert update.save
    assert_equal update.slug, 'this-is-a-title'
    update = Update.create(title: 'This is a title', text: 'This is the body.')
    assert update.save
    assert_equal update.slug, "this-is-a-title-#{Date.today.to_s.parameterize}"
  end
end
