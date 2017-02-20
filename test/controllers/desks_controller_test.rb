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
end
