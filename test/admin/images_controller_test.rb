require 'active_admin_helper'

module Admin
  # Make sure we can perform basic image administration
  class ImagesControllerTest < ActionController::TestCase
    include ActiveAdminHelper

    setup :initialize_image

    test 'should get index' do
      get :index
      assert_response :success
    end

    test 'should get show' do
      get :show, id: @image.id
      assert_response :success
    end

    test 'should get edit' do
      get :edit, id: @image.id
      assert_response :success
    end

    test 'should update' do
      patch :update, id: @image.id, image: @image.attributes
      assert_redirected_to admin_image_path(assigns(:image))
    end

    test 'should destroy' do
      assert_difference('Image.count', -1) do
        delete :destroy, id: @image.id
      end

      assert_redirected_to admin_images_path
    end

    private

    def initialize_image
      @image = images(:one)
    end
  end
end
