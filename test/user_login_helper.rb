module UserLoginHelper

  private

  def sign_in_admin_for(subject)
    @request.env['devise.mapping'] = Devise.mappings[:user]
    user = users(:one)
    user.add_role(:admin, subject)
    sign_in user
  end
end
