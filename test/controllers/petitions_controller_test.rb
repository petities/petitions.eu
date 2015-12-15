require 'test_helper'

class PetitionsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

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

  test "should_create_petition" do
    assert_no_difference('User.count') do
      assert_difference('Petition.count') do
        post :create, {
          petition: {
            name: @petition.name + 'x' ,
            description: @petition.description + 'x',
            initiators: @petition.initiators + 'y',
            statement: @petition.statement + 'test',
            request: @petition.request + 'teest',
            office_id: 1
          },
          user: {
            email: 'test@test.com', # user already exists
            name: 'test'
          }
        }
      end
    end

    assert_redirected_to petition_path(assigns(:petition))
  end

  test "should_create_petition_and_user" do
    assert_difference('User.count') do
      assert_difference('Petition.count') do
        post :create, {
          petition: {
            name: @petition.name + 'x' ,
            description: @petition.description + 'x',
            initiators: @petition.initiators + 'y',
            statement: @petition.statement + 'test',
            request: @petition.request + 'teest',
            office_id: 1
          },
          user: {
            email: 'idonotexist@test.com',
            name: 'nexttest',
            password: 'idonotexist@test.com'
          }
        }
      end
    end

    assert_redirected_to petition_path(assigns(:petition))

  end

  test "should_create_petition_user_and_password" do
    assert_difference('User.count') do
      assert_difference('Petition.count') do
        post :create, {
          petition: {
            name: @petition.name + 'x' ,
            description: @petition.description + 'x',
            initiators: @petition.initiators + 'y',
            statement: @petition.statement + 'test',
            request: @petition.request + 'teest',
            office_id: 1
          },
          user: {
            email: 'idonotexist@test.com',
            name: 'nexttest',
          }
        }
      end
    end

    assert_redirected_to petition_path(assigns(:petition))

  end


  test "should show petition" do
    get :show, id: @petition.id
    assert_response :success
  end
  
  test "should show petition slug" do
    get :show, id: @petition.friendly_id
    assert_response :success
  end

  test "should not get edit" do
    get :edit, id: @petition
    assert_redirected_to root_path 
  end

  test "should_get_edit" do
    # user has admin rights on petition 1
    @request.env["devise.mapping"] = Devise.mappings[:user]
    u = User.find(1) 
    u.confirm
    u.add_role(:admin, @petition)
    sign_in u
    get :edit, id: @petition.friendly_id
    assert_response :success
  end

  #test "should update petition" do
  #  patch :update, id: @petition, petition: { name: 'newtitle', description: @petition.description }
  #  assert_redirected_to petition_path(assigns(:petition))
  #end

  #test "should destroy petition" do
  #  assert_difference('Petition.count', -1) do
  #    delete :destroy, id: @petition
  #  end

  #  assert_redirected_to petitions_path
  #end
end
