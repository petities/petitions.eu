require 'test_helper'

class MarkdownHelperTest < ActionView::TestCase
  include MarkdownHelper

  test 'markdown' do
    markdown = 'This is *bongos*, indeed.'
    assert_equal markdown(markdown).strip, '<p>This is <em>bongos</em>, indeed.</p>'
  end

  test 'markdown should strip html' do
    input = 'This is a <blink>test</blink> string.'
    assert_equal markdown(input).strip, '<p>This is a test string.</p>'
  end

  test 'strip_markdown should remove markdown' do
    markdown = 'This is *bongos*, indeed.'
    assert_equal strip_markdown(markdown).strip, 'This is bongos, indeed.'
  end

  test 'strip_markdown should remove html' do
    input = 'This is a <blink>test</blink> string.'
    assert_equal strip_markdown(input).strip, 'This is a test string.'
  end
end
