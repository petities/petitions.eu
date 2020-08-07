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
    assert_equal petition_share_url(@petition), 'http://test.host/petitions/testslug'
  end

  test 'petition_status_options' do
    assert_equal petition_status_options.size, Petition::POSSIBLE_STATES.size
    withdrawn = petition_status_options.first
    assert_equal withdrawn, [t('petition.states.withdrawn'), 'withdrawn']
  end
end
