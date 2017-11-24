require 'test_helper'

class DashboardControllerTest < ActionController::TestCase
  include UserLoginHelper

  setup do
    @petition = petitions(:one)
  end

  test 'should show my petitions when logged in' do
    sign_in_admin_for @petition

    get :show
    assert_response :success
    assert assigns(:petitions)
    assert_includes assigns(:petitions), @petition
    assert_select 'h1' #petition-section-title'
  end
end
