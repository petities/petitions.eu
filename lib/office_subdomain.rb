class OfficeSubdomain
  def self.matches?(request)
    if request.subdomain.present?
      @office = Office.find_by_subdomain(request.subdomain)
      return true if @office
    end
  end
end
