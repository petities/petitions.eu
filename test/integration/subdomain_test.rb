class SubDomainTest < ActionDispatch::IntegrationTest
  fixtures :all

  test 'bad subdomain' do
    host! 'idonotexist.test.host'
    assert_recognizes({ controller: 'petitions', action: 'index' }, 'http://idontexist.test.host')
    get '/'
    assert_response :success
  end

  test 'amsterdam subdomain' do
    host! 'amsterdam.test.host'
    assert_recognizes({ controller: 'desks', action: 'redirect' }, 'http://amsterdam.test.host')
    get '/'
    assert_response :redirect
    assert_redirected_to 'http://test.host/petitions/desks/amsterdam'
  end

  test 'petition subdomain domain' do
    host! 'testsubdomain.test.host'
    assert_recognizes({ controller: 'petitions', action: 'show' }, 'http://testsubdomain.test.host')
    get '/'
    assert_response :success
  end
end
