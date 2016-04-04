require 'test_helper'


class PagesTest < ActionDispatch::IntegrationTest
  %w(drugs test xxx nothing).each do |q|
    test "loading of search page #{q}" do
      get "/petitions/search?search=#{q}"
      assert_response :success
    end
  end
end
