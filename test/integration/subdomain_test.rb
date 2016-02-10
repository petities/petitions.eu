
class SubDomainTest < ActionDispatch::IntegrationTest
  fixtures :all

  test 'bad subdomain' do
    host! 'idonotexist.localhost.nl'
    assert_recognizes({ controller: 'petitions', action: 'index' }, 'http://idontexist.localhost.nl')
    get '/'
    assert_response :success
  end

  test 'amsterdam subdomain' do
    host! 'amsterdam.localhost.nl'
    # byebug
    # assert_recognizes({ controller: 'desks', action: 'show' }, 'http://amsterdam.localhost.nl')
    get '/'
    assert_response :redirect
  end

  test 'petition subdomain domain' do
    host! 'testsubdomain.localhost.nl'
    assert_recognizes({ controller: 'petitions', action: 'show' }, 'http://testsubdomain.localhost.nl')
    get '/'
    assert_response :success
  end
end
