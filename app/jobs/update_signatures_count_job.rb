# Recalculate the petitions signatures_count
class UpdateSignaturesCountJob < ActiveJob::Base
  queue_as :default

  def perform(petition)
    count = petition.signatures.count

    old_count = petition.signatures_count
    petition.update_column(:signatures_count, count) if old_count != count

    cached_counter = RedisPetitionCounter.new(petition)
    cached_counter.delete unless petition.is_live?
    cached_counter.update_with_limit(count)
  end
end
