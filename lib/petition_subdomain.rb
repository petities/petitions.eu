class PetitionSubdomain
  def self.matches?(request)
    subdomain = request.subdomain
    Petition.where(subdomain: subdomain).any? if subdomain.present?
  end
end
