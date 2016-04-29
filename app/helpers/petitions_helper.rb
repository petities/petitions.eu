module PetitionsHelper

  def cache_key_for_petitions
    count          = Petition.count || 1
    max_updated_at = Petition.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "petitions/all-#{count}-#{max_updated_at}"
  end

  def petition_share_url(petition)
    return "https://#{petition.subdomain}.petities.nl" if @petition.subdomain.present?
    petition_url(petition)
  end

end
