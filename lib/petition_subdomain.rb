class PetitionSubdomain
  def self.matches?(request)
    if request.subdomain.present?
      @petition = Petition.find_by_subdomain(request.subdomain)
      return true if @petition
    end
  end
end
