require 'active_admin_helper'

module Admin
  # Make sure we can perform basic allowed_city administration
  class AllowedCitiesControllerTest < ActionController::TestCase
    include ActiveAdminHelper

    setup :initialize_allowed_city

    test 'should get index' do
      get :index
      assert_response :success
    end

    test 'should get show' do
      get :show, id: @allowed_city.id
      assert_response :success
    end

    test 'should get edit' do
      get :edit, id: @allowed_city.id
      assert_response :success
    end

    test 'should update' do
      patch :update, id: @allowed_city.id, allowed_city: @allowed_city.attributes
      assert_redirected_to admin_allowed_city_path(assigns(:allowed_city))
    end

    test 'should destroy' do
      assert_difference('AllowedCity.count', -1) do
        delete :destroy, id: @allowed_city.id
      end

      assert_redirected_to admin_allowed_cities_path
    end

    private

    def initialize_allowed_city
      @allowed_city = allowed_cities(:one)
    end
  end
end
