require 'test_helper'

module Admin
  # Make sure we can perform basic signature administration
  class SignaturesControllerTest < ActionController::TestCase
    include Devise::TestHelpers

    setup :login_admin, :initialize_signature

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

    test 'should update signature' do
      patch :update, id: @signature.id, signature: @signature.attributes
      assert_redirected_to admin_signature_path(assigns(:signature))
    end

    test 'should destroy signature' do
      assert_difference('Signature.count', -1) do
        delete :destroy, id: @signature.id
      end

      assert_redirected_to admin_signatures_path
    end

    private

    def login_admin
      @request.env['devise.mapping'] = Devise.mappings[:admin]
      sign_in admin_users(:one)
    end

    def initialize_signature
      @signature = signatures(:one)
    end
  end
end
