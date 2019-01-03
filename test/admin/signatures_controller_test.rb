require 'active_admin_helper'

module Admin
  # Make sure we can perform basic signature administration
  class SignaturesControllerTest < ActionController::TestCase
    include ActiveAdminHelper

    setup :initialize_signature

    test 'should get index' do
      get :index
      assert_response :success
      assert_select('span.status_tag.no', 'Nee')
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

    test 'should set batch to invisible' do
      post :batch_action, batch_action: 'invisible', collection_selection: [@signature.id]
      @signature.reload
      assert_not @signature.visible?
      assert_equal I18n.t('active_admin.signatures.batch_invisible'), flash[:notice]
      assert_redirected_to admin_signatures_path
    end

    test 'should set batch to unsubscribe' do
      post :batch_action, batch_action: 'unsubscribe', collection_selection: [@signature.id]
      @signature.reload
      assert_not @signature.subscribe?
      assert_not @signature.more_information?
      assert_equal I18n.t('active_admin.signatures.batch_unsubscribe'), flash[:notice]
      assert_redirected_to admin_signatures_path
    end

    private

    def initialize_signature
      @signature = signatures(:four)
    end
  end
end
