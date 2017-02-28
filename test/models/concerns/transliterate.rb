module Concerns
  # For example, use assert_transliterate(@signature, :person_email) to test if
  # @signature.person_email was converted before_validation
  module Transliterate
    def assert_transliterate(matcher, field)
      matcher.send("#{field}=", 'tést@example.cóm')
      matcher.valid?
      assert_equal('test@example.com', matcher.send(field))
    end
  end
end
