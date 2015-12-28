require 'test_helper'

class ProfileControllerTest < ActionController::TestCase
  test 'should get edit' do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    u = User.find(1)
    u.confirm
    sign_in u
    get :edit
    assert_response :success
  end
end
