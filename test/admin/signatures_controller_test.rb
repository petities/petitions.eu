require 'active_admin_helper'

module Admin
  # Make sure we can perform basic signature administration
  class SignaturesControllerTest < ActionController::TestCase
    include ActiveAdminHelper

    setup :initialize_signature

    test 'should get index' do
      get :index
      assert_response :success
    end

    test 'should get show' do
      get :show, id: @signature.id
      assert_response :success
    end

    test 'should get edit' do
      get :edit, id: @signature.id
      assert_response :success
    end

    test 'should update' do
      patch :update, id: @signature.id, signature: @signature.attributes
      assert_redirected_to admin_signature_path(assigns(:signature))
    end

    test 'should destroy' do
      assert_difference('Signature.count', -1) do
        delete :destroy, id: @signature.id
      end

      assert_redirected_to admin_signatures_path
    end

    private

    def initialize_signature
      @signature = signatures(:four)
    end
  end
end
