require 'active_admin_helper'

module Admin
  # Make sure we can perform basic cities administration
  class CitiesControllerTest < ActionController::TestCase
    include ActiveAdminHelper

    setup :initialize_city

    test 'should get index' do
      get :index
      assert_response :success
    end

    test 'should get show' do
      get :show, id: @city.id
      assert_response :success
    end

    test 'should get edit' do
      get :edit, id: @city.id
      assert_response :success
    end

    test 'should update' do
      patch :update, id: @city.id, city: @city.attributes
      assert_redirected_to admin_city_path(assigns(:city))
    end

    test 'should destroy' do
      assert_difference('City.count', -1) do
        delete :destroy, id: @city.id
      end

      assert_redirected_to admin_cities_path
    end

    test 'should create' do
      assert_difference('City.count', 1) do
        post :create, city: { name: 'Groningen',
                              imported_at: Time.zone.now,
                              imported_from: 'Testcase'
                            }
      end

      assert_redirected_to admin_city_path(assigns(:city))
    end

    private

    def initialize_city
      @city = cities(:amsterdam)
    end
  end
end
