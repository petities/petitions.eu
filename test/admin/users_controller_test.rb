require 'active_admin_helper'

module Admin
  # Make sure we can perform basic user administration
  class UsersControllerTest < ActionController::TestCase
    include ActiveAdminHelper

    setup :initialize_user

    test 'should get index' do
      get :index
      assert_response :success
    end

    test 'should get show' do
      get :show, id: @user.id
      assert_response :success
    end

    test 'should get edit' do
      get :edit, id: @user.id
      assert_response :success
    end

    test 'should update' do
      patch :update, id: @user.id, user: @user.attributes
      assert_redirected_to admin_user_path(assigns(:user))
    end

    test 'should destroy' do
      assert_difference('User.count', -1) do
        delete :destroy, id: @user.id
      end

      assert_redirected_to admin_users_path
    end

    test 'should put resend_confirmation_instructions' do
      user = users(:unconfirmed)
      assert_difference 'ActionMailer::Base.deliveries.size' do
        put :resend_confirmation_instructions, id: user
      end
      # assert_enqueued_jobs 1
      assert_redirected_to admin_user_path(user)
    end

    private

    def initialize_user
      @user = users(:one)
    end
  end
end
