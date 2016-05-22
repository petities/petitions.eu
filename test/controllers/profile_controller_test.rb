require 'test_helper'

class ProfileControllerTest < ActionController::TestCase
  test 'should get edit' do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    user = users(:one)
    user.confirm
    sign_in user
    get :edit
    assert_response :success
  end
end
