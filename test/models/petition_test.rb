require 'test_helper'
require 'models/concerns/strip_whitespace'

class PetitionTest < ActiveSupport::TestCase
  include Concerns::StripWhitespace

  setup do
    @petition = petitions(:one)
  end

  test 'strip leading and trailing whitespace' do
    [:name, :description, :initiators, :statement, :request].each do |field|
      assert_strip_whitespace @petition, field
    end
  end
end
