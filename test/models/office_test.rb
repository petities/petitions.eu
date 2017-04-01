require 'test_helper'

class OfficeTest < ActiveSupport::TestCase
  test 'default_office should find' do
    assert_equal(Office.default_office.email, offices(:nederland).email)
  end
end
