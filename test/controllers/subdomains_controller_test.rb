require 'test_helper'

class SubdomainsControllerTest < ActionController::TestCase
  test 'office should redirect' do
    @office = offices(:amsterdam)
    @request.host = "#{@office.subdomain}.test.host"

    get :show
    assert_response :redirect
    assert_redirected_to "http://test.host/petitions/desks/#{@office.friendly_id}"
  end

  test 'unknown should render 404' do
    @request.host = 'does-not-exist.test.host'

    assert_raises ActionController::RoutingError do
      get :show
      assert_response :not_found
    end
  end
end
