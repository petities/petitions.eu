module SignaturesHelper
  def cache_key_for_signatures(petition)
    petition_id = petition.id
    petition_sigs = Signature.where(petition_id: petition.id)
    count          = petition_sigs.count
    max_updated_at = petition_sigs.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "sigs/all-#{petition_id}-#{count}-#{max_updated_at}"
  end
end
