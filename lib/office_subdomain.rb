class OfficeSubdomain

  def self.matches?(request)
    if request.subdomain.present?
      @office = Office.find_by_subdomain(request.subdomain)
      if @office
        return true
      end
    end
  end
end
