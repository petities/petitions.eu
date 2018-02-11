require 'test_helper'

class RedisPetitionCounterTest < ActiveSupport::TestCase
  setup do
    @petition = petitions(:one)
    @counter = RedisPetitionCounter.new(@petition)
  end

  test 'should update key' do
    assert @counter.update(42)
    assert_equal @counter.count, 42
  end

  test 'should delete key' do
    @counter.update(@petition.signatures_count)
    assert @counter.exists?
    @counter.delete
    assert_not @counter.exists?
  end

  test 'should return count with class method' do
    @counter.update(42)
    assert_equal RedisPetitionCounter.count(@petition), 42
  end
end
