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

  test 'markdown should render tables' do
    text = 'Provincie | Inwoners
------------ | -------------
Groningen | 583.635
Drenthe | 488.505'
    assert_match '<table>', markdown(text).strip
  end

  test 'markdown should render footnotes' do
    text = 'This is a test[^1] string.

[^1]: test: a procedure for checking quality.'
    assert_match '<sup id="fnref1">', markdown(text).strip
    assert_match '<div class="footnotes">', markdown(text).strip
  end
end
