require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  include ApplicationHelper

  test 'header_username with name' do
    user_with_name = User.new(name: 'John Doe', email: 'j.doe@example.com')
    assert_equal(header_username(user_with_name), user_with_name.name)
  end

  test 'header_username without name' do
    user_with_name = User.new(email: 'j.doe@example.com')
    assert_equal(header_username(user_with_name), user_with_name.email)
  end

  test 'header_username without current_user' do
    assert_equal(header_username(nil), 'U, de petitionaris')
  end
end
