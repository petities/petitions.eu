require 'test_helper'
require 'models/concerns/strip_whitespace'

class SignatureTest < ActiveSupport::TestCase
  include Concerns::StripWhitespace

  setup do
    @signature = signatures(:four)
  end

  test 'strip leading and trailing whitespace' do
    [:person_city, :person_email, :person_function, :person_name, :person_street_number].each do |field|
      assert_strip_whitespace @signature, field
    end
  end

  test 'browser should be truncated' do
    value = 'Mozilla/5.0 (Windows NT 6.0; rv:32.0) Gecko/20100101 Firefox/32.0 Facicons Facicons Facicons Facicons Facicons Facicons Facicons Facicons Facicons Facicons Facicons Facicons Facicons Facicons Facicons Facicons Facicons Facicons Facicons Facicons Facicons Facicons Facicons Facicons Facicons Facicons Facicons Facicons Facicons Facicons Facicons Facicons Facicons Facicons Facicons Facicons Facicons Facicons Facicons Facicons Facicons Facicons Facicons'
    @signature.signature_remote_browser = value
    @signature.confirmation_remote_browser = value
    @signature.save
    assert_equal @signature.signature_remote_browser.length, 255
    assert_equal @signature.confirmation_remote_browser.length, 255
  end

  test 'sort_order should be integer' do
    @signature.sort_order = nil
    @signature.save
    assert_equal @signature.sort_order, 0
  end
end
