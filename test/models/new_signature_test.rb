require 'test_helper'

class NewSignatureTest < ActiveSupport::TestCase
  setup do
    @signature = NewSignature.create(
      person_name: 'Test Name',
      person_email: 'test@example.com'
    )
  end

  test 'should be valid' do
    assert @signature.valid?
  end

  test 'signature should have unique_key after save' do
    assert_not_empty @signature.unique_key
  end

  test 'should have signed_at after save' do
    assert_equal 'Time', @signature.signed_at.class.name
  end

  test 'should make signatures email case insensitive' do
    duplicate_signature = NewSignature.new(
      person_name: 'Test Name',
      person_email: 'TEST@EXAMPLE.COM'
    )
    assert_not duplicate_signature.valid?
    assert duplicate_signature.errors.keys.include?(:person_email)
  end
end
