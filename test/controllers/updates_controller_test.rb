require 'test_helper'

class UpdatesControllerTest < ActionController::TestCase
  include UserLoginHelper

  setup do
    @update = updates(:one)
  end

  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should get index.rss' do
    get :index, format: :rss
    assert_response :success
  end

  test 'should get index as petitioner' do
    @petition = petitions(:one)
    sign_in_admin_for @petition
    get :index
    assert_response :success
  end

  test 'should get show' do
    get :show, id: @update
    assert_response :success
  end
end
