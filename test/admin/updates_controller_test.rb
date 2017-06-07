require 'active_admin_helper'

module Admin
  # Make sure we can perform basic update administration
  class UpdatesControllerTest < ActionController::TestCase
    include ActiveAdminHelper

    setup :initialize_update

    test 'should get index' do
      get :index
      assert_response :success
    end

    test 'should get show' do
      get :show, id: @update.id
      assert_response :success
    end

    test 'should get edit' do
      get :edit, id: @update.id
      assert_response :success
    end

    test 'should update' do
      patch :update, id: @update.id, update: @update.attributes
      assert_redirected_to admin_update_path(assigns(:update))
    end

    test 'should destroy' do
      assert_difference('Update.count', -1) do
        delete :destroy, id: @update.id
      end

      assert_redirected_to admin_updates_path
    end

    test 'should create' do
      assert_difference('Update.count', 1) do
        post :create, update: { title: 'This is a very nice title',
                                text: 'One could write a text here.',
                                show_on_home: true,
                                show_on_office: false,
                                show_on_petition: false
                            }
      end

      assert_redirected_to admin_update_path(assigns(:update))
    end

    private

    def initialize_update
      @update = updates(:one)
    end
  end
end
