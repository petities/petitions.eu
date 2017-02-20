# Match all subdomains except www
class SubdomainConstraint
  def self.matches?(request)
    request.subdomain.present? && request.subdomain != 'www'
  end
end
