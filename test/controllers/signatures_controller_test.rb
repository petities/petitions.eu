require 'test_helper'

class SignaturesControllerTest < ActionController::TestCase
  fixtures :all

  setup do
    @petition = petitions(:one)
    @signature = signatures(:one)

    @petition2 = petitions(:two)
    @signature2 = signatures(:two)

    @newsignature = new_signatures(:two)
  end

  # test "should get index" do
  #  get :index
  #  assert_response :success
  #  assert_not_nil assigns(:signatures)
  # end

  # test "should get new" do
  #  get :new, :petition_id => 1
  #  assert_response :success
  # end

  test 'should create signature' do
    assert_difference('NewSignature.count') do
      post :create, format: :js, petition_id: @petition, signature: {
        #:petition_id => @petitions.id,
        person_name: 'test name',
        person_email: 'test2@gmail.com',
        person_city: 'test city',
        visible: true,
        special: true,
        subscribe: true,
        created_at: Time.now,
        updated_at: Time.now,
        signed_at: Time.now,
        confirmed_at: Time.now,
        confirmed: false
      }
    end
    assert_response :success
  end

  # this petition / signature requires full address
  test 'should not update signature' do
    # byebug
    post :confirm_submit, format: :json, petition_id: @petition2,
                          signature_id: @signature2.unique_key, signature: {
                            visible: true,
                            special: true,
                            subscribe: true
                          }
    assert_response :unprocessable_entity
  end

  # this petition / signature requires NOTHING
  test 'should update signature' do
    post :confirm_submit, format: :json, petition_id: @petition,
                          signature_id: @signature.unique_key, signature: {
                            visible: true,
                            special: true,
                            subscribe: true,
                            persone_function: true,
                            street_number: 'X'
                          }
    assert_response :success
  end

  # test the validation
  test 'valdation signature' do
    post :confirm_submit, format: :json, petition_id: @petition2,
                          signature_id: @signature2.unique_key, signature: {
                            visible: true,
                            special: true,
                            subscribe: true,
                            persone_function: true,
                            # wrong values
                            street_number: 'X',
                            person_street: 'XX',
                            person_birth_city: 'X',
                            person_born_at: 'X'
                          }
    assert_response :unprocessable_entity

    error_keys = JSON.load(response.body).keys
    assert_empty(error_keys - %w(
      person_street person_street_number person_born_at
      person_birth_city))
  end

  test 'signature confirmation links' do
    assert_routing('/signatures/10/confirm', controller: 'signatures',
                                             action: 'confirm', signature_id: '10')

    assert_routing('/signatures/xx/confirm', controller: 'signatures',
                                             action: 'confirm', signature_id: 'xx')

    assert_recognizes({
                        controller: 'signatures',
                        action: 'confirm',
                        signature_id: 'oude_id_blabla' },
                      '/ondertekening/oude_id_blabla')

    assert_recognizes({
                        controller: 'signatures',
                        action: 'confirm',
                        signature_id: 'oude_id_blabla' },
                      '/ondertekening/oude_id_blabla/confirm')
  end

  test 'check confirmation logic' do
    assert_difference('NewSignature.count', -1) do
      assert_difference('Signature.count') do
        assert_difference('Petition.find(2).signatures_count') do
          get :confirm, signature_id: @newsignature.unique_key
        end
      end
    end

    # when we do it again nothing should happen.
    assert_no_difference('NewSignature.count') do
      assert_no_difference('Signature.count') do
        assert_no_difference('Petition.find(2).signatures_count') do
          get :confirm, signature_id: @newsignature.unique_key
        end
      end
    end
  end

  # test 'take_owner_ship' do
  #   assert_difference('User.count') do
  #     assert_difference('Role.count') do
  #       get :become_petition_owner, signature_id: @newsignature.unique_key
  #     end
  #   end
  # end

  # test "should show signature" do
  #  get :show, id: @signature
  #  assert_response :success
  # end

  # test "should get edit" do
  #  get :edit, id: @signature
  #  assert_response :success
  # end

  # test "should update signature" do
  #  patch :update, id: @signature, signature: {  }
  #  #assert_redirected_to signature_path(assigns(:signature))
  #  assert_redirected_to petition_path(@petition)
  # end

  # test "should destroy signature" do
  #  assert_difference('Signature.count', -1) do
  #    delete :destroy, id: @signature
  #  end

  #  assert_redirected_to signatures_path
  # end
end
