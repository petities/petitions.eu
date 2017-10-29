require 'test_helper'

class SignaturesControllerTest < ActionController::TestCase
  include UserLoginHelper
  fixtures :all

  setup do
    @petition = petitions(:one)
    @signature = signatures(:four)

    @petition_with_required_fields = petitions(:two)
    @new_signature = new_signatures(:two)
  end

  test 'should get index' do
   get :index, petition_id: @petition.id
   assert_response :success
   assert_not_nil assigns(:petition)
   assert_not_nil assigns(:signatures)
  end

  test 'should get latest' do
   get :latest, petition_id: @petition.id
   assert_response :success
   assert_not_nil assigns(:petition)
   assert_not_nil assigns(:signatures)
  end

  # test "should get new" do
  #  get :new, :petition_id => 1
  #  assert_response :success
  # end

  test 'should create signature' do
    @request.env['REMOTE_ADDR'] = '127.0.0.1'
    @request.env['HTTP_USER_AGENT'] = 'Mozilla/5.0 (iPad; U; CPU OS 3_2_1 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Mobile/7B405'

    assert_difference('NewSignature.count') do
      post :create, format: :js, petition_id: @petition, signature: {
        person_name: 'test name',
        person_email: 'test2@gmail.com',
        person_city: 'test city',
        visible: true,
        special: false,
        subscribe: true,
        created_at: Time.now,
        updated_at: Time.now,
        signed_at: Time.now,
        confirmed_at: Time.now,
        confirmed: false
      }
    end

    assert_response :success
    signature = assigns(:signature)
    assert_equal '127.0.0.1', signature.signature_remote_addr
    assert_equal 'Mozilla/5.0 (iPad; U; CPU OS 3_2_1 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Mobile/7B405', signature.signature_remote_browser
  end

  # this petition / signature requires full address
  test 'should not update signature' do
    post :confirm_submit, format: :json, petition_id: @petition_with_required_fields,
                          signature_id: @new_signature.unique_key, signature: {
                            visible: true,
                            special: false,
                            subscribe: true
                          }
    assert_response :unprocessable_entity
  end

  # this petition / signature requires NOTHING
  test 'should update signature' do
    post :confirm_submit, format: :json, petition_id: @petition,
                          signature_id: @signature.unique_key, signature: {
                            visible: true,
                            special: false,
                            subscribe: true,
                            persone_function: true,
                            street_number: 'X'
                          }
    assert_response :success
  end

  # test the validation
  test 'validation signature' do
    post :confirm_submit, format: :json, petition_id: @petition_with_required_fields,
                          signature_id: @new_signature.unique_key, signature: {
                            visible: true,
                            special: false,
                            subscribe: true,
                            # wrong values
                            street_number: 'X',
                            person_street: 'XX',
                            person_birth_city: 'X',
                            person_born_at: 'X'
                          }
    assert_response :unprocessable_entity

    error_keys = JSON.load(response.body).keys
    assert_empty(error_keys - %w[
      person_street person_street_number person_born_at
      person_birth_city])
  end

  test 'should not update signature function when length is invalid' do
    post :confirm_submit, format: :json, petition_id: @petition,
                          signature_id: @signature.unique_key, signature: {
                            person_function: '1' * 500
                          }

    assert_response :unprocessable_entity
  end

  test 'should update signature function' do
    post :confirm_submit, format: :json, petition_id: @petition,
                          signature_id: @signature.unique_key, signature: {
                            person_function: '1' * 253
                          }

    assert_response :success
  end

  test 'should refuse special signature for anonymous user' do
    assert_no_difference('Signature.special.count') do
      post :special_update, format: :json,
                            id: @signature.id, signature: { special: 1 }
    end

    assert_response :unauthorized
  end

  test 'should update special signature for petition admin' do
    sign_in_admin_for @petition

    assert_difference('Signature.special.count') do
      post :special_update, format: :json,
                            id: @signature.id, signature: { special: 1 }
    end

    assert_response :success
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
    # remove redis keys
    # mabe we should have a test prefix..
    if $redis.keys("p-d-#{@petition_with_required_fields.id}-*").size > 0
      $redis.del($redis.keys("p-d-#{@petition_with_required_fields.id}-*"))
    end

    assert_difference('NewSignature.count', -1) do
      assert_difference('Signature.count') do
        assert_difference('$redis.get("p#{@petition_with_required_fields.id}-count").to_i') do
        #assert_difference('Petition.find(2).signatures_count') do
          get :confirm, signature_id: @new_signature.unique_key
        end
      end
    end

    old_value = @petition_with_required_fields.active_rate
    assert_equal($redis.keys("p-d-#{@petition_with_required_fields.id}-*").size, 1)
    assert_not_equal(@petition_with_required_fields.active_rate, 0.01)
    assert_equal(@petition.active_rate, 0.01)

    # when we do it again nothing should happen.
    assert_no_difference('NewSignature.count') do
      assert_no_difference('Signature.count') do
        #assert_no_difference('Petition.find(2).signatures_count') do
        assert_no_difference('$redis.get("p2-count").to_i') do
          get :confirm, signature_id: @new_signature.unique_key
        end
      end
    end

    assert_equal(@petition_with_required_fields.active_rate, old_value)
  end

  test 'confirmation not_found' do
    get :confirm, signature_id: 'random-non-existing-code'
    assert_response :not_found
    assert_template 'not_found'
  end

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
