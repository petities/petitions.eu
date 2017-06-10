require 'active_admin_helper'

module Admin
  # Make sure we can perform basic petition_type administration
  class PetitionTypesControllerTest < ActionController::TestCase
    include ActiveAdminHelper

    setup :initialize_petition_type

    test 'should get index' do
      get :index
      assert_response :success
    end

    test 'should get show' do
      get :show, id: @petition_type.id
      assert_response :success
    end

    test 'should get new' do
      get :new
      assert_response :success
    end

    test 'should create' do
      input_values = petition_types(:custom_texts).attributes
      post :create, petition_type: input_values
      petition_type = assigns(:petition_type)
      assert_redirected_to admin_petition_type_path(petition_type)

      petition_type.attributes
                   .except('id', 'created_at', 'updated_at')
                   .each do |key, value|
        assert_equal input_values[key], value
      end
    end

    test 'should get edit' do
      get :edit, id: @petition_type.id
      assert_response :success
    end

    test 'should update' do
      patch :update, id: @petition_type.id, petition_type: @petition_type.attributes
      assert_redirected_to admin_petition_type_path(assigns(:petition_type))
    end

    test 'should destroy' do
      assert_difference('PetitionType.count', -1) do
        delete :destroy, id: @petition_type.id
      end

      assert_redirected_to admin_petition_types_path
    end

    private

    def initialize_petition_type
      @petition_type = petition_types(:netherlands)
    end
  end
end
