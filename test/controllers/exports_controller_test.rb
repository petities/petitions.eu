require 'test_helper'

class ExportsControllerTest < ActionController::TestCase
  include UserLoginHelper

  setup do
    @petition = petitions(:one)
  end

  test 'should get show as anonymous user' do
    get :show, petition_id: @petition
    assert_response :redirect
    assert_equal @petition, assigns(:petition)
    assert_redirected_to root_path
    assert_not_nil flash[:error]
  end

  test 'should get show as petition admin for html' do
    sign_in_admin_for @petition
    get :show, petition_id: @petition
    assert_response :redirect
    assert_redirected_to petition_signatures_path(@petition)
  end

  test 'should get show as petition admin for pdf' do
    sign_in_admin_for @petition
    get :show, petition_id: @petition, format: :pdf
    assert_response :success
    assert_equal 'application/pdf', @response.content_type
  end

  test 'should get show as petition admin for csv' do
    sign_in_admin_for @petition
    get :show, petition_id: @petition, format: :csv
    assert_response :success
    assert_equal 'text/csv', @response.content_type
  end
end
