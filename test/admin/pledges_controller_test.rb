require 'active_admin_helper'

module Admin
  # Make sure we can perform basic pledge administration
  class PledgesControllerTest < ActionController::TestCase
    include ActiveAdminHelper

    setup :initialize_pledge

    test 'should get index' do
      get :index
      assert_response :success
    end

    test 'should get show' do
      get :show, id: @pledge
      assert_response :success
    end

    test 'should get edit' do
      get :edit, id: @pledge
      assert_response :success
    end

    test 'should update' do
      patch :update, id: @pledge, update: @pledge.attributes
      assert_redirected_to admin_pledge_path(assigns(:pledge))
    end

    test 'should destroy' do
      assert_difference('Pledge.count', -1) do
        delete :destroy, id: @pledge
      end

      assert_redirected_to admin_pledges_path
    end

    test 'should create' do
      assert_difference('Pledge.count', 1) do
        post :create, pledge: { petition_id: petitions(:one).id,
                                signture_id: signatures(:four).id,
                                money: 25
                            }
      end

      assert_redirected_to admin_pledge_path(assigns(:pledge))
    end

    private

    def initialize_pledge
      @pledge = pledges(:one)
    end
  end
end
