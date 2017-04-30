require 'test_helper'

class SubDomainTest < ActionDispatch::IntegrationTest
  fixtures :all

  test 'bad subdomain' do
    host! 'idonotexist.test.host'
    assert_recognizes({ controller: 'subdomains', action: 'show' }, 'http://idontexist.test.host')
    get '/'
    assert_response :not_found
  end

  test 'office amsterdam subdomain' do
    host! 'amsterdam.test.host'
    assert_recognizes({ controller: 'subdomains', action: 'show' }, 'http://amsterdam.test.host')
    get '/'
    assert_response :redirect
    assert_redirected_to 'http://test.host/petitions/desks/amsterdam'
  end

  test 'petition subdomain domain' do
    host! 'testsubdomain.test.host'
    assert_recognizes({ controller: 'petitions', action: 'show' }, 'http://testsubdomain.test.host')
    get '/'
    assert_response :success
    assert_select 'a.header-logo[href=?]', 'http://test.host/?locale=nl'
    # Allow translations for subdomain
    get '/?locale=en'
    assert_response :success
  end

  test 'petition recent signatures via subdomain' do
    petition = petitions(:one)
    host! petition.subdomain + '.test.host'
    get latest_petition_signatures_url(petition)
    assert_response :success
  end

end
