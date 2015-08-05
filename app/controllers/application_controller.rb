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

  def help
    @faq_questions = Faq.all
  end

  def render_404
    render 'shared/404'
  end

  private

    def user_not_authorized(exception)
      policy_name = exception.policy.class.to_s.underscore

      flash[:error] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
      redirect_to(request.referrer || root_path)
    end

    def set_locale
      available_locales = [:ag, :de, :en, :es, :fr, :lim, :nl]

      if params[:locale]
        I18n.locale = if available_locales.include? params[:locale].to_sym
                        params[:locale]
                      else
                        I18n.default_locale
                      end
      else
        I18n.locale = http_accept_language.compatible_language_from(available_locales) || I18n.default_locale
      end
    end

    def default_url_options(options = {})
      { locale: I18n.locale }
    end


end
