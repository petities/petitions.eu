require 'test_helper'
require 'models/concerns/strip_whitespace'

class SignatureTest < ActiveSupport::TestCase
  include Concerns::StripWhitespace

  setup do
    @signature = signatures(:one)
  end

  test 'strip leading and trailing whitespace' do
    [:person_city, :person_email, :person_function, :person_name, :person_street_number].each do |field|
      assert_strip_whitespace @signature, field
    end
  end
end
