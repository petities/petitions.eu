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



  #around_action :with_locale
  before_filter :set_locale

  private

    def user_not_authorized(exception)
      policy_name = exception.policy.class.to_s.underscore

      flash[:error] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
      redirect_to(request.referrer || root_path)
    end

    def set_locale
      if params[:locale]
        I18n.locale = params[:locale] || I18n.default_locale
      else 
        I18n.locale = http_accept_language.compatible_language_from(I18n.available_locales)
      end
    end

    def default_url_options(options = {})
      { locale: I18n.locale }
    end


end
