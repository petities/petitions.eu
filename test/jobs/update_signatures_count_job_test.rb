require 'test_helper'

class UpdateSignaturesCountJobTest < ActiveJob::TestCase
  setup do
    @petition = petitions(:one)
  end

  test 'updates signature_count value' do
    Redis.current.set("p#{@petition.id}-count", 4)
    assert_not_equal @petition.signatures.size, @petition.signatures_count

    UpdateSignaturesCountJob.perform_now(@petition)

    assert_equal(@petition.signatures.size, @petition.signatures_count)
    redis_count = Redis.current.get("p#{@petition.id}-count")
    assert_equal(@petition.signatures.size, redis_count.to_i)
  end

  test 'limits redis_count adjustment to 5' do
    Redis.current.set("p#{@petition.id}-count", 40)

    UpdateSignaturesCountJob.perform_now(@petition)

    redis_count = Redis.current.get("p#{@petition.id}-count")
    assert_equal(35, redis_count.to_i)
  end
end
