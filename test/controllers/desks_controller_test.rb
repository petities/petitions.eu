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
end
