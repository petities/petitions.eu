require 'test_helper'

class PetitionsControllerTest < ActionController::TestCase
  setup do
    @petition = petitions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:petitions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create petition" do
    assert_difference('Petition.count') do
      post :create, petition: { text: @petition.text, title: @petition.title }
    end

    assert_redirected_to petition_path(assigns(:petition))
  end

  test "should show petition" do
    get :show, id: @petition
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @petition
    assert_response :success
  end

  test "should update petition" do
    patch :update, id: @petition, petition: { text: @petition.text, title: @petition.title }
    assert_redirected_to petition_path(assigns(:petition))
  end

  test "should destroy petition" do
    assert_difference('Petition.count', -1) do
      delete :destroy, id: @petition
    end

    assert_redirected_to petitions_path
  end
end
