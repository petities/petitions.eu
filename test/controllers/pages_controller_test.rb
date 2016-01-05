require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  PagesController::STATIC_PAGES.each do |action|
    test "should get #{action}" do
      get action
      assert_response :success
    end
  end
end
