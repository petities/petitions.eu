require 'test_helper'

# Make sure these pages keep working when moving to new controller
# during refactoring
class PagesTest < ActionDispatch::IntegrationTest
  %w[about contact help privacy].each do |name|
    test "loading of page #{name}" do
      get "/#{name}"
      assert_response :success
    end
  end

  test 'redirect of donations' do
    get '/donate'
    assert_response :redirect
    assert_redirected_to 'https://betaalverzoek.rabobank.nl/betaalverzoek/?id=MX3AG14USwamtfVmuwZxng'
  end
end
