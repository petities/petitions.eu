module PetitionsHelper

  def cache_key_for_petitions
    count          = Petition.count || 1
    max_updated_at = Petition.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "petitions/all-#{count}-#{max_updated_at}"
  end

  def last_sig_update petition
    last_d = petition.last_confirmed_at
    last = $redis.get('p%s-last' % petition.id)
    if last
      last = Time.parse(last)
    end
    last || last_d
  end
end
