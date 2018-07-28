# Recalculate the petitions signatures_count and last_confirmed_at attributes.
class UpdateSignaturesCacheJob < ActiveJob::Base
  queue_as :low_priority

  def perform(petition)
    @petition = petition

    recalculate_signatures_count
    recalculate_last_confirmed_at
  end

  private

  attr_reader :petition

  def recalculate_signatures_count
    count = petition.signatures.count

    old_count = petition.signatures_count
    petition.update_column(:signatures_count, count) if old_count != count

    cached_counter = RedisPetitionCounter.new(petition)
    cached_counter.delete unless petition.is_live?
    cached_counter.update_with_limit(count)
  end

  def recalculate_last_confirmed_at
    last_confirmed_at = petition.signatures.last&.confirmed_at

    if last_confirmed_at && last_confirmed_at != petition.last_confirmed_at
      petition.update_column(:last_confirmed_at, last_confirmed_at)
    end
  end

end
