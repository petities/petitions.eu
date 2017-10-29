class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protect_from_forgery with: :exception

  # around_action :with_locale
  before_action :set_locale
  before_action :ensure_domain

  before_action do
    @news = Update.show_on_home.limit(7) if request.get?
  end

  # redirect users..
  def after_sign_in_path_for(resource)
    stored_location_for(resource) ||
      if resource.is_a?(AdminUser)
        admin_dashboard_path
      elsif !Office.with_role(:admin, resource).empty?
        office = Office.with_role(:admin, resource).first
        petition_desk_path(office)
      else
        root_path
      end
  end

  def render_404
    respond_to do |format|
      format.html { render file: "#{Rails.root}/app/views/pages/error", status: :not_found }
      format.xml  { head :not_found }
      format.any  { head :not_found }
    end
  end

  private

  def subdomain?
    unless request.subdomain.empty?
      return true unless %w[dev www api].include?(request.subdomain)
    end
    false
  end

  # redirect subdomains which are not direct 'hits'
  # to a url without subdomain
  # only for get requests
  def ensure_domain
    if request.get? && subdomain?
      unless request.path == '/'
        redirect_to request.url.sub(request.subdomain + '.', '')
      end
    end
  end

  def user_not_authorized(exception)
    authenticate_user!

    referer = request.referer unless request.referer == request.url
    policy_name = exception.policy.class.to_s.underscore
    flash[:error] = t("#{policy_name}.#{exception.query}", scope: 'pundit', default: :default)
    redirect_to(referer || root_path)
  end

  def set_locale
    available_locales = I18n.available_locales
    requested_locale = params[:locale].to_s.downcase.to_sym

    if requested_locale && available_locales.include?(requested_locale)
      I18n.locale = params[:locale]
    else
      I18n.locale = I18n.default_locale
    end
  end

  def default_url_options(options = {})
    protocol = 'https'
    protocol = 'http' if Rails.env.development? || Rails.env.test?

    { locale: I18n.locale,
      protocol: protocol
    }.merge(options)
  end

  # Page should be a integer, value 1 or larger
  def cleanup_page(input)
    page = input.to_i
    page > 0 ? page : 1
  end
end
