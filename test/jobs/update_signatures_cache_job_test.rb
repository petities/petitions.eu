require 'test_helper'

class UpdateSignaturesCacheJobTest < ActiveJob::TestCase
  setup do
    @petition = petitions(:one)
  end

  test 'updates signature_count value' do
    Redis.current.set("p#{@petition.id}-count", 4)
    assert_not_equal(@petition.signatures.size, @petition.signatures_count)

    UpdateSignaturesCacheJob.perform_now(@petition)

    assert_equal(@petition.signatures.size, @petition.signatures_count)
    redis_count = Redis.current.get("p#{@petition.id}-count")
    assert_equal(@petition.signatures.size, redis_count.to_i)
  end

  test 'limits redis_count adjustment to 5' do
    Redis.current.set("p#{@petition.id}-count", 40)

    UpdateSignaturesCacheJob.perform_now(@petition)

    redis_count = Redis.current.get("p#{@petition.id}-count")
    assert_equal(35, redis_count.to_i)
  end

  test 'updates last_confirmed_at value' do
    last_confirmed_at = @petition.signatures.last.confirmed_at
    assert_not_equal(last_confirmed_at, @petition.last_confirmed_at)

    UpdateSignaturesCacheJob.perform_now(@petition)

    assert_equal(last_confirmed_at, last_confirmed_at)
  end
end
