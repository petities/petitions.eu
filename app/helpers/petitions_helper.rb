module PetitionsHelper
  def petition_share_url(petition)
    return "https://#{petition.subdomain}.petities.nl" if petition.subdomain.present?
    petition_url(petition)
  end
end
