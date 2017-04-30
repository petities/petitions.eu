require 'test_helper'

class PledgeTest < ActiveSupport::TestCase
  test 'should set petition_id on create' do
    signature = signatures(:four)
    assert_nil signature.pledge
    pledge = signature.create_pledge
    assert pledge.petition.present?
  end
end
