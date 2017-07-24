require 'test_helper'

# Make sure these pages keep working when moving to new controller
# during refactoring
class PagesTest < ActionDispatch::IntegrationTest
  %w[about contact donate help privacy].each do |name|
    test "loading of page #{name}" do
      get "/#{name}"
      assert_response :success
    end
  end
end
