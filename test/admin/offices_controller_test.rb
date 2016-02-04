require 'active_admin_helper'

module Admin
  # Make sure we can perform basic office administration
  class OfficesControllerTest < ActionController::TestCase
    include ActiveAdminHelper

    setup :initialize_office

    test 'should get index' do
      get :index
      assert_response :success
    end

    test 'should get show' do
      get :show, id: @office
      assert_response :success
    end

    test 'should get edit' do
      get :edit, id: @office
      assert_response :success
    end

    test 'should update' do
      patch :update, id: @office, update: @office.attributes
      assert_redirected_to admin_office_path(assigns(:office))
    end

    test 'should destroy' do
      assert_difference('Office.count', -1) do
        delete :destroy, id: @office
      end

      assert_redirected_to admin_offices_path
    end

    test 'should create' do
      assert_difference('Office.count', 1) do
        post :create, office: { name: 'This is a nice title',
                                description: 'The petition that is used for testing',
                                hidden: false,
                                subdomain: 'testoffice'
                              }
      end

      assert_redirected_to admin_office_path(assigns(:office))
    end

    private

    def initialize_office
      @office = offices(:amsterdam)
    end
  end
end
