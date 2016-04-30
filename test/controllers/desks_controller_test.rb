require 'test_helper'

class DesksControllerTest < ActionController::TestCase
  include UserLoginHelper

  setup do
    @office = offices(:amsterdam)
  end

  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should get show' do
    get :show, id: @office
    assert_response :success
  end

  test 'should redirect' do
    @request.host = "#{@office.subdomain}.test.host"
    get :redirect
    assert_response :redirect
    assert_redirected_to "http://test.host/petitions/desks/#{@office.friendly_id}"
  end
end
