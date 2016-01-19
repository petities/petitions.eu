require 'active_admin_helper'

module Admin
  # Make sure we can perform basic petition_translation administration
  class PetitionTranslationsControllerTest < ActionController::TestCase
    include ActiveAdminHelper

    setup :initialize_petition_translation

    test 'should get index' do
      get :index
      assert_response :success
    end

    test 'should get show' do
      get :show, id: @petition_translation.id
      assert_response :success
    end

    test 'should get edit' do
      get :edit, id: @petition_translation.id
      assert_response :success
    end

    test 'should update' do
      patch :update, id: @petition_translation.id, petition_tranlation: @petition_translation.attributes
      assert_redirected_to admin_petition_translation_path(assigns(:petition_translation))
    end

    test 'should destroy' do
      assert_difference('PetitionTranslation.count', -1) do
        delete :destroy, id: @petition_translation.id
      end

      assert_redirected_to admin_petition_translations_path
    end

    private

    def initialize_petition_translation
      @petition_translation = petition_translations(:one)
    end
  end
end
