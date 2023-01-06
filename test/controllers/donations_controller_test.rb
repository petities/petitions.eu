require 'test_helper'

class DonationsControllerTest < ActionController::TestCase
  test 'should redirect index to payment request' do
    get :index
    assert_response :redirect
    assert_redirected_to 'https://betaalverzoek.rabobank.nl/betaalverzoek/?id=MX3AG14USwamtfVmuwZxng'
  end
end
