require 'active_admin_helper'

module Admin
  # Make sure we can perform basic organisation administration
  class OrganisationsControllerTest < ActionController::TestCase
    include ActiveAdminHelper

    setup :initialize_organisation

    test 'should get index' do
      get :index
      assert_response :success
    end

    test 'should get show' do
      get :show, id: @organisation
      assert_response :success
    end

    test 'should get edit' do
      get :edit, id: @organisation
      assert_response :success
    end

    test 'should update' do
      patch :update, id: @organisation, update: @organisation.attributes
      assert_redirected_to admin_organisation_path(assigns(:organisation))
    end

    test 'should destroy' do
      assert_difference('Organisation.count', -1) do
        delete :destroy, id: @organisation
      end

      assert_redirected_to admin_organisations_path
    end

    test 'should create' do
      assert_difference('Organisation.count', 1) do
        post :create, organisation: { name: 'Provincie Limburg',
                                      kind: 'district',
                                      code: '',
                                      region: '',
                                      visible: true
                                    }
      end

      assert_redirected_to admin_organisation_path(assigns(:organisation))
    end

    private

    def initialize_organisation
      @organisation = organisations(:one)
    end
  end
end
