require 'active_admin_helper'

module Admin
  # Make sure we can perform basic petition administration
  class PetitionsControllerTest < ActionController::TestCase
    include ActiveAdminHelper

    setup :initialize_petition

    test 'should get index' do
      get :index
      assert_response :success
    end

    test 'should get show' do
      get :show, id: @petition
      assert_response :success
    end

    test 'should get show contains translations' do
      get :show, id: @petition
      assert_equal @petition.translations.size, 1

      assert_select 'div#translations_sidebar_section table' do |elements|
        elements.each do |element|
          assert_select element, 'tbody tr', @petition.translations.size
        end
      end
    end

    test 'should get show contains users' do
      get :show, id: @petition
      assert_equal @petition.users.size, 3

      assert_select 'div#users_sidebar_section table' do |elements|
        elements.each do |element|
          assert_select element, 'tbody tr', @petition.users.size
        end
      end
    end

    test 'should get show contains newsletters' do
      get :show, id: @petition
      assert_equal @petition.newsletters.size, 1

      assert_select 'div#newsletters_sidebar_section table' do |elements|
        elements.each do |element|
          assert_select element, 'tbody tr', @petition.newsletters.size
        end
      end
    end

    test 'should put update_signature_count' do
      put :update_signature_count, id: @petition
      assert_enqueued_jobs 1
      assert_redirected_to admin_petition_path(@petition)
    end

    test 'should get edit' do
      get :edit, id: @petition
      assert_response :success
    end

    test 'should update' do
      patch :update, id: @petition, update: @petition.attributes
      assert_redirected_to admin_petition_path(assigns(:petition))
    end

    test 'should destroy' do
      assert_difference('Petition.count', -1) do
        delete :destroy, id: @petition
      end

      assert_redirected_to admin_petitions_path
    end

    test 'should create' do
      assert_difference('Petition.count', 1) do
        post :create, petition: { name: 'This is a nice title',
                                  description: 'The petition that is used for testing',
                                  initiators: 'We, the developers',
                                  statement: 'Testing the software',
                                  request: 'This test to pass',
                                  petitioner_name: 'T. Tester',
                                  petitioner_email: 'test@example.com'
                                }
      end

      assert_redirected_to admin_petition_path(assigns(:petition))
    end

    private

    def initialize_petition
      @petition = petitions(:one)
    end
  end
end
