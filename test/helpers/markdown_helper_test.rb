require 'test_helper'

class MarkdownHelperTest < ActionView::TestCase
  include MarkdownHelper

  test 'strip_markdown' do
    markdown = 'This is *bongos*, indeed.'
    assert_equal strip_markdown(markdown).strip, 'This is bongos, indeed.'
  end
end
