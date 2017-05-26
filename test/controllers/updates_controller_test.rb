require 'test_helper'

class UpdatesControllerTest < ActionController::TestCase
  setup do
    @update = updates(:one)
  end

  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should get show' do
    get :show, id: @update
    assert_response :success
  end
end
