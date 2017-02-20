require 'test_helper'

class PetitionsControllerTest < ActionController::TestCase
  include UserLoginHelper

  setup do
    @petition = petitions(:one)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:petitions)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'new should render nested images form' do
    get :new
    assert_select 'input#petition_images_attributes_0_upload'
  end

  test 'should_create_petition' do
    assert_no_difference('Update.count') do
      assert_no_difference('User.count') do
        assert_difference('Petition.count') do
          post :create, petition: {
            name: @petition.name + 'x',
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
        end
      end
    end

    assert_redirected_to petition_path(assigns(:petition))
  end

  test 'should_create_petition_and_user' do
    assert_no_difference('Update.count') do
      assert_difference('User.count') do
        assert_difference('Petition.count') do
          post :create, petition: {
            name: @petition.name + 'x',
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
        end
      end
    end

    assert_redirected_to petition_path(assigns(:petition))
  end

  test 'should show petition when using id' do
    get :show, id: @petition.id
    assert_response :success
  end

  test 'should show petition when using slug' do
    get :show, id: @petition.friendly_id
    assert_response :success
  end

  test 'should show petitioner form to add news' do
    sign_in_admin_for @petition
    [:show, :edit].each do |action|
      get action, id: @petition
      assert assigns(:update)
      assert_select 'form#new_update'
    end
  end

  test 'should show my petitions' do
    sign_in_admin_for @petition
    [:manage].each do |action|
      get action, id: @petition
      assert assigns(:petitions)
      assert_select 'h1' #petition-section-title'
    end
  end

  test 'should not get edit' do
    get :edit, id: @petition
    assert_redirected_to root_path
  end

  test 'should_get_edit' do
    sign_in_admin_for @petition
    get :edit, id: @petition.friendly_id
    assert_response :success

    # Should have image upload and destroy inputs.
    assert_select 'input#petition_images_attributes_0_upload'
    assert_select 'input#petition_images_attributes_0__destroy'
  end

  test 'should_get_limited_edit' do
    sign_in_admin_for @petition
    $redis.set("p#{@petition.id}-count", 200)
    get :edit, id: @petition.friendly_id
    assert_response :success
    assert_not_nil assigns(:exclude_list)
    assert_equal(
      [:name, :subdomain, :initiators, :statement, :request],
      assigns(:exclude_list)
    )
  end

  test 'should get edit as office admin' do
    sign_in_admin_for @petition.office
    get :edit, id: @petition.friendly_id
    assert_response :success
  end

  test 'should update petition' do
    sign_in_admin_for @petition
    patch :update, id: @petition.id, petition: {
      name: 'newtitle',
      description: @petition.description,
      images_attributes: { "0": { _destroy: 1, id: @petition.image.id}}
    }
    updated_petition = assigns(:petition)
    assert_redirected_to edit_petition_path(updated_petition)
    assert updated_petition.images.none?
  end

  test 'should finalize petition' do
    sign_in_admin_for @petition.office

    get :finalize, petition_id: @petition.id

    @petition.reload

    assert_equal('live', @petition.status)
  end

  test 'should status change petition' do
    sign_in_admin_for @petition
    # two mails should be send on status change

    assert_enqueued_jobs 4 do

      patch :update, id: @petition.id, petition: { status: 'draft' }

      @petition.reload

      assert_equal('draft', @petition.status)

      assert_redirected_to edit_petition_path(assigns(:petition))
    end
  end

  test 'should not status change petition' do
    assert_enqueued_jobs 0

    status = @petition.status

    patch :update, id: @petition.id, petition: { status: 'draft' }

    assert_equal(status, @petition.status)

    assert_redirected_to root_path

    assert_enqueued_jobs 0
  end

  # test "should destroy petition" do
  #  assert_difference('Petition.count', -1) do
  #    delete :destroy, id: @petition
  #  end

  #  assert_redirected_to petitions_path
  # end
end
