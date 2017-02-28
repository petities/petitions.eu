require 'test_helper'

class InvitesControllerTest < ActionController::TestCase
  setup do
    @signature = signatures(:four)
    @petition = @signature.petition
  end

  test 'should post create' do
    recipient = 'invite@example.com'
    post :create, petition_id: @petition.id,
                  signature_id: @signature.unique_key,
                  invite_form: { mail: recipient }
    assert_response :success
    assert_match 'application/json', @response.header['Content-Type']
  end

  test 'should render error message on error' do
    post :create, petition_id: @petition.id,
                  signature_id: @signature.unique_key,
                  invite_form: { mail: '' }
    assert_response :bad_request
    error_message = JSON.parse(response.body)
    assert_equal error_message['mail'], ['is ongeldig']
  end
end
