require 'test_helper'

class SignatureTest < ActiveSupport::TestCase
  include Concerns::StripWhitespace
  include Concerns::TruncateString

  setup do
    @signature = signatures(:four)
  end

  test 'strip leading and trailing whitespace' do
    [:person_city, :person_email, :person_function, :person_name, :person_street_number].each do |field|
      assert_strip_whitespace @signature, field
    end
  end

  test 'browser fields should be truncated at column limit' do
    [:signature_remote_browser, :confirmation_remote_browser].each do |field|
      assert_truncate_string @signature, field
    end
  end

  test 'sort_order should be integer' do
    @signature.sort_order = nil
    @signature.save
    assert_equal @signature.sort_order, 0
  end
end
