require 'test_helper'

class DesksControllerTest < ActionController::TestCase
  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should get show' do
    @office = offices(:amsterdam)
    get :show, id: @office
    assert_response :success
  end

  test 'should redirect' do
    @office = offices(:amsterdam)
    @request.host = "#{@office.subdomain}.test.host"
    get :redirect
    assert_response :redirect
    assert_redirected_to "http://test.host/petitions/desks/#{@office.friendly_id}"
  end
end
