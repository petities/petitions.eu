class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protect_from_forgery with: :exception

  if Rails.env.test?
    protect_from_forgery with: :null_session
  else
    protect_from_forgery with: :exception
  end

  # around_action :with_locale
  before_action :set_locale
  before_action :ensure_domain

  before_action do
    # @news = Update.website_news.limit(12) if request.get?
    @news = Update.show_on_home.limit(12) if request.get?
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
        #manage_petitions_path
      end
  end

  def help
    @general = I18n.t('help.general').map { |_key, value| value }
    @whilesigning = I18n.t('help.whilesigning').map { |_key, value| value }
    @aftersigning = I18n.t('help.aftersigning').map { |_key, value| value }
    @writingpetition = I18n.t('help.writingpetition').map { |_key, value| value }
  end

  %w(about privacy donate contact).each do |name|
    define_method(name) {}
  end

  def contact_submit
    ApplicationMailer.contact_mail(params[:from], params[:body]).deliver

    flash[:notice] = 'Your email was successfully sent to website administrator!'
    redirect_to contact_path
  end

  def render_404
    render 'shared/404'
  end

  private

  def has_subdomain?
    unless request.subdomain.empty?
      return true unless %w(dev www api).include? request.subdomain
    end
    false
  end

  # redirect subdomains which are not direct 'hits'
  # to a url without subdomain
  def ensure_domain
    if has_subdomain?
      unless request.fullpath == '/'
        redirect_to request.url.sub(request.subdomain + '.', '')
      end
    end
  end

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore
    flash[:error] = t "#{policy_name}.#{exception.query}", scope: 'pundit', default: :default
    redirect_to(request.referrer || root_path)
  end

  def set_locale
    available_locales = [:ag, :de, :en, :es, :fr, :lim, :nl]

    if params[:locale]
      I18n.locale = if available_locales.include? params[:locale].downcase.to_sym
                      params[:locale]
                    else
                      I18n.default_locale
                    end
    else
      I18n.locale = http_accept_language.compatible_language_from(available_locales) || I18n.default_locale
    end
  end

  def default_url_options(_options = {})
    { locale: I18n.locale }
  end
end
