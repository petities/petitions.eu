require 'test_helper'

class SearchTest < ActionDispatch::IntegrationTest
  %w(onderwijs gezondheidszorg referendum verkeer).each do |q|
    test "loading of search page #{q}" do
      get search_petitions_url(search: q)
      assert_response :success
    end
  end
end
