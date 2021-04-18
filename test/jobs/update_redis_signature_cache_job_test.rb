require 'test_helper'

class UpdateRedisSignatureCacheJobTest < ActiveJob::TestCase
  setup do
    @petition = petitions(:one)
  end

  test 'updates signature count in redis' do
    Redis.current.set("p#{@petition.id}-count", 24)
    assert(@petition.signatures.any?)

    UpdateRedisSignatureCacheJob.perform_now(@petition)

    redis_count = Redis.current.get("p#{@petition.id}-count")
    assert_equal(redis_count.to_i, @petition.signatures.count)
  end

  test 'removes redis cache for closed petitions' do
    @petition.update_attribute(:status, 'completed')
    Redis.current.set("p#{@petition.id}-count", 24)

    UpdateRedisSignatureCacheJob.perform_now(@petition)

    redis_counter = Redis.current.exists?("p#{@petition.id}-count")
    assert_equal(redis_counter, false)
  end
end
