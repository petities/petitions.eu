require 'active_admin_helper'

module Admin
  # Make sure we can perform basic new_signature administration
  class NewSignaturesControllerTest < ActionController::TestCase
    include ActiveAdminHelper

    setup :initialize_new_signature

    test 'should get index' do
      get :index
      assert_response :success
    end

    test 'should get show' do
      get :show, id: @new_signature.id
      assert_response :success
    end

    test 'should get edit' do
      get :edit, id: @new_signature.id
      assert_response :success
    end

    test 'should update' do
      patch :update, id: @new_signature.id, new_signature: @new_signature.attributes
      assert_redirected_to admin_new_signature_path(assigns(:new_signature))
    end

    test 'should destroy' do
      assert_difference('NewSignature.count', -1) do
        delete :destroy, id: @new_signature.id
      end

      assert_redirected_to admin_new_signatures_path
    end

    private

    def initialize_new_signature
      @new_signature = new_signatures(:one)
    end
  end
end
