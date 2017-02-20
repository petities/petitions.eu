module Concerns
  # For example, use assert_truncate_string(@petition, :name) to test if
  # @petition.name is truncated to 255 characters before_validation
  module TruncateString
    def assert_truncate_string(matcher, field)
      matcher.send("#{field}=", 'A' * 300)
      matcher.valid?
      assert 255, matcher.send(field).length
    end
  end
end
