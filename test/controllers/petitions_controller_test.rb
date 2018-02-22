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

  test 'should get all' do
    get :all
    assert_response :success
    assert_not_nil assigns(:petitions)
  end

  test 'should get all with invalid pages' do
    [0, 'invalid-text', 43_000].each do |value|
      get :all, page: value
      assert_response :success
    end
  end

  test 'should get all withdrawn' do
    petition = petitions(:three)
    petition.update_attribute(:status, 'withdrawn')

    get :all, sorting: 'withdrawn'
    assert_response :success
    assert_not_nil assigns(:petitions)

    assert_equal assigns(:petitions).first.status, 'withdrawn'
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'new should render nested images form' do
    get :new
    assert_select 'input#petition_images_attributes_0_upload'
  end

  test 'should_create_petition_and_reuse_existing_user' do
    assert_no_difference('Update.count') do
      assert_no_difference('User.count') do
        assert_difference('Petition.count') do
          post :create, petition: {
            name: @petition.name,
            description: @petition.description,
            initiators: @petition.initiators,
            statement: @petition.statement,
            request: @petition.request,
            office_id: 1
          },
          user: {
            email: 'test@test.com', # user already exists
            name: 'test'
          }
        end
      end
    end

    created_petitition = assigns(:petition)
    assert_redirected_to petition_path(created_petitition)
    [:name, :description, :initiators, :statement, :request].each do |attribute|
      assert_equal @petition.send(attribute), created_petitition.send(attribute)
    end
    assert_equal 'test@test.com', created_petitition.petitioner_email
    assert_equal 'test', created_petitition.petitioner_name
  end

  test 'should_create_petition_and_user' do
    assert_no_difference('Update.count') do
      assert_difference('User.count') do
        assert_difference('Petition.count') do
          post :create, petition: {
            name: @petition.name,
            description: @petition.description,
            initiators: @petition.initiators,
            statement: @petition.statement,
            request: @petition.request,
            office_id: 1
          },
          user: {
            email: 'idonotexist@test.com',
            name: 'nexttest'
          }
        end
      end
    end

    created_petitition = assigns(:petition)
    assert_redirected_to petition_path(created_petitition)
    [:name, :description, :initiators, :statement, :request].each do |attribute|
      assert_equal @petition.send(attribute), created_petitition.send(attribute)
    end
    assert_equal 'idonotexist@test.com', created_petitition.petitioner_email
    assert_equal 'nexttest', created_petitition.petitioner_name
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

  test 'should not get edit' do
    get :edit, id: @petition
    assert_authenticate_user
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
    Redis.current.set("p#{@petition.id}-count", 200)
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

  test 'should finalize petition for Office admin' do
    @petition.update_attribute(:status, 'staging')

    sign_in_admin_for @petition.office

    get :finalize, petition_id: @petition.id

    updated_petition = assigns(:petition)
    assert_equal('live', updated_petition.status)
    assert_not_equal(90.days.from_now.to_date, updated_petition.date_projected)
    assert_redirected_to edit_petition_path(updated_petition)

    [nil, 2.days.ago].each do |date_projected|
      @petition.update_attribute(:date_projected, date_projected)
      get :finalize, petition_id: @petition.id

      updated_petition = assigns(:petition)
      assert_equal('live', updated_petition.status)
      assert_equal(90.days.from_now.to_date, updated_petition.date_projected)
    end
  end

  test 'should finalize petition for Petition admin' do
    @petition.update_attribute(:status, 'concept')

    sign_in_admin_for @petition

    # 6 status_change messages and 1 finalize_mail
    assert_enqueued_jobs 7 do
      get :finalize, petition_id: @petition.id
    end

    updated_petition = assigns(:petition)
    assert_equal('staging', updated_petition.status)
    assert_redirected_to edit_petition_path(updated_petition)
  end

  test 'should status change petition' do
    sign_in_admin_for @petition

    # mails should be send on status change
    assert_enqueued_jobs 6 do

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

    @petition.reload

    assert_equal(status, @petition.status)

    assert_authenticate_user

    assert_enqueued_jobs 0
  end

  # test "should destroy petition" do
  #  assert_difference('Petition.count', -1) do
  #    delete :destroy, id: @petition
  #  end

  #  assert_redirected_to petitions_path
  # end

  def assert_authenticate_user
    assert_redirected_to new_user_session_path(locale: nil)
  end
end
