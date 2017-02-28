module Concerns
  # For example, use assert_strip_whitespace(@petition, :name) to test if
  # @petition.name has leading and trailing whitespace removed before_validation
  module StripWhitespace
    def assert_strip_whitespace(matcher, field)
      matcher.send("#{field}=", ' some value ')
      matcher.valid?
      assert_equal('some value', matcher.send(field))
    end
  end
end
