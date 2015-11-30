
class PetitionSubdomain

  def self.matches?(request)
    if request.subdomain.present?
      @petition = Petition.find_by_subdomain(request.subdomain)
      if @petition
        return true
      end
    end
  end
end
