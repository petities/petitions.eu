require 'test_helper'

class InvitesControllerTest < ActionController::TestCase
  setup do
    @signature = signatures(:one)
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

  test 'should render unprocessable_entity on error' do
    recipient = 'invite@example.com'
    post :create, petition_id: @petition.id,
                  signature_id: @signature.unique_key,
                  invite_form: { mail: '' }
    assert_response :unprocessable_entity
  end
end
