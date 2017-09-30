require 'active_admin_helper'

module Admin
  # Make sure we can perform basic newsletter administration
  class NewslettersControllerTest < ActionController::TestCase
    include ActiveAdminHelper

    setup :initialize_newsletter

    test 'should get index' do
      get :index
      assert_response :success
    end

    test 'should get show' do
      get :show, id: @newsletter
      assert_response :success
    end

    test 'should get edit' do
      get :edit, id: @newsletter
      assert_response :success
    end

    test 'should update' do
      patch :update, id: @newsletter, update: @newsletter.attributes
      assert_redirected_to admin_newsletter_path(assigns(:newsletter))
    end

    test 'should destroy' do
      assert_difference('Newsletter.count', -1) do
        delete :destroy, id: @newsletter
      end

      assert_redirected_to admin_newsletters_path
    end

    test 'should create' do
      assert_difference('Newsletter.count', 1) do
        post :create, newsletter: { petition_id: petitions(:one).id,
                                    text: 'One could write a text here.',
                                    date: Date.today,
                                    published: true
                                  }
      end

      assert_redirected_to admin_newsletter_path(assigns(:newsletter))
    end

    private

    def initialize_newsletter
      @newsletter = newsletters(:one)
    end
  end
end
