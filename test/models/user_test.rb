require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'conversion of old authlogic passwords' do
    user = users(:with_authlogic_password)
    assert user.valid_password?('password')

    # Assert password was converted to bcrypt
    assert user.encrypted_password.include?('$2a$')
  end
end
