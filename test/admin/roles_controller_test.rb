require 'active_admin_helper'

module Admin
  # Make sure we can perform basic role administration
  class RolesControllerTest < ActionController::TestCase
    include ActiveAdminHelper

    setup :initialize_role

    test 'should get index' do
      get :index
      assert_response :success
    end

    test 'should get show' do
      get :show, id: @role.id
      assert_response :success
    end

    test 'should get new' do
      get :new
      assert_response :success
    end

    test 'should create' do
      assert_difference('Role.count', 1) do
        post :create, role: { name: 'Manager loket Amsterdam',
                              resource: offices(:amsterdam) }
      end

      assert_redirected_to admin_role_path(assigns(:role))
    end

    test 'should get edit' do
      get :edit, id: @role.id
      assert_response :success
    end

    test 'should update' do
      patch :update, id: @role.id, role: @role.attributes
      assert_redirected_to admin_role_path(assigns(:role))
    end

    test 'should destroy' do
      assert_difference('Role.count', -1) do
        delete :destroy, id: @role.id
      end

      assert_redirected_to admin_roles_path
    end

    private

    def initialize_role
      @role = roles(:one)
    end
  end
end
