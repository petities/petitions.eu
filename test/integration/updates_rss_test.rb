require 'test_helper'
require 'rss'

class UpdatesRSSTest < ActionDispatch::IntegrationTest
  test "rss feed for newsitems" do
    get updates_url(format: :rss)
    assert_response :success

    feed = RSS::Parser.parse(response.body)
    assert feed.valid?
  end
end
