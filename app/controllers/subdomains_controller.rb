class SubdomainsController < ApplicationController
  skip_before_action :ensure_domain

  def show
    redirect_office or not_found
  end

  def redirect_office
    @office = Office.find_by(subdomain: request.subdomain)
    redirect_to petition_desk_url(@office, subdomain: nil, locale: nil) if @office
  end

  def not_found
    raise ActionController::RoutingError, 'Not Found'
  end
end
