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

  test 'should get show as office admin' do
    sign_in_admin_for @office
    get :show, id: @office
    assert_response :success
  end

  test 'should filter petitions on show' do
    get :show, id: @office, page: 2, sorting: :concluded
    assert_response :success
    assert_select 'div.petitions-overview-sort-options-container span.active', 'Afgehandeld'
    # Search options should be without :page
    assert_select 'div.petitions-overview-sort-options-container a[href=?]', petition_desk_path(@office, sorting: :all)
  end
end
