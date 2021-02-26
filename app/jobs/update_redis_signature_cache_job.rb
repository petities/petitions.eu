# Recalculate the signature counter cache in Redis for live petitions
class UpdateRedisSignatureCacheJob < ActiveJob::Base
  queue_as :low_priority

  def perform(petition)
    cached_counter = RedisPetitionCounter.new(petition)

    if petition.is_live?
      count = petition.signatures.count
      cached_counter.update(count)
    else
      cached_counter.delete
    end
  end
end
