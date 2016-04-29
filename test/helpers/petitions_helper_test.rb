require 'test_helper'

class PetitionsHelperTest < ActionView::TestCase
  include PetitionsHelper

  setup do
    @petition = petitions(:one)
  end

  test 'petition_share_url with subdomain' do
    assert_equal petition_share_url(@petition), 'https://testsubdomain.petities.nl'
  end

  test 'petition_share_url without subdomain' do
    @petition.subdomain = nil
    assert_equal petition_share_url(@petition), 'http://test.host/petitions/testsubdomain'
  end
end
