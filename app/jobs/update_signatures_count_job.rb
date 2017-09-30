# Recalculate the petitions signatures_count
class UpdateSignaturesCountJob < ActiveJob::Base
  queue_as :default

  def perform(petition)
    count = petition.signatures.count

    old_count = petition.signatures_count
    petition.update_column(:signatures_count, count) if old_count != count
    RedisPetitionCounter.new(petition).update_with_limit(count)
  end
end
