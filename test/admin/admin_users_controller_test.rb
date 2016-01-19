require 'active_admin_helper'

module Admin
  # Make sure we can perform basic admin_user administration
  class AdminUsersControllerTest < ActionController::TestCase
    include ActiveAdminHelper

    setup :initialize_admin_user

    test 'should get index' do
      get :index
      assert_response :success
    end

    test 'should get show' do
      get :show, id: @admin_user.id
      assert_response :success
    end

    test 'should get edit' do
      get :edit, id: @admin_user.id
      assert_response :success
    end

    test 'should update' do
      patch :update, id: @admin_user.id, admin_user: @admin_user.attributes
      assert_redirected_to admin_admin_user_path(assigns(:admin_user))
    end

    test 'should destroy' do
      assert_difference('AdminUser.count', -1) do
        delete :destroy, id: @admin_user.id
      end

      assert_redirected_to admin_admin_users_path
    end

    private

    def initialize_admin_user
      @admin_user = admin_users(:one)
    end
  end
end
