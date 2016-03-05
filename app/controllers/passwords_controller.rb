class PasswordsController < Devise::PasswordsController
  prepend_before_action :require_no_authentication
  append_before_action :assert_reset_token_passed, only: :edit

  def new; end

  def create
    user = User.where(email: params[:email]).first

    user.send_reset_password_instructions if user && user.email

    flash[:notice] = t("login.flash.sent", email: params[:email])

    redirect_to new_user_session_path
  end

  def update
    self.resource = resource_class.reset_password_by_token(resource_params)

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)

      flash[:notice] = t('login.flash.success')
      respond_with resource, location: after_resetting_password_path_for(resource)
    else
      respond_with resource
    end
  end

  protected

  def after_resetting_password_path_for(_resource)
    new_session_path(resource_name)
  end
end
