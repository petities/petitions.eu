require 'test_helper'

class PetitionStatusMailTest < ActiveSupport::TestCase
  setup do
    @petition = petitions(:one)
    @builder = PetitionStatusMail.new(@petition)
  end

  # We send messages to:
  # - The petitioner public address
  # - All users with a role for the petition
  # - The office public address
  # - The default office public address
  test 'should build list of recipients' do
    assert_equal(@builder.recipients.size, 6)
    assert_includes(@builder.recipients, @petition.petitioner_email)
    @petition.users.each do |user|
      assert_includes(@builder.recipients, user.email)
    end
    assert_includes(@builder.recipients, @petition.office.email)
    assert_includes(@builder.recipients, Office.default_office.email)
  end

  test 'should send messages' do
    assert_enqueued_jobs 6 do
      @builder.call
    end
  end
end
