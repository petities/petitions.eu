require 'test_helper'

class ContactControllerTest < ActionController::TestCase
  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should post create and get redirected' do
    @request.env['REMOTE_ADDR'] = '127.0.0.1'
    @request.env['HTTP_USER_AGENT'] = 'Mozilla/5.0 (iPad; U; CPU OS 3_2_1 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Mobile/7B405'

    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      post :create, contact_form: {
        name: 'Example Name',
        mail: 'name@example.com',
        subject: 'Message to test',
        message: 'I would like to send you a message'
      }
    end

    contact_form = assigns(:contact_form)
    assert_equal '127.0.0.1', contact_form.remote_ip
    assert_equal 'Mozilla/5.0 (iPad; U; CPU OS 3_2_1 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Mobile/7B405', contact_form.browser

    assert_redirected_to contact_thanks_url
  end

  test 'should post create and render on error' do
    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      post :create, contact_form: {
        name: 'Example Name',
        mail: 'name@example',
        message: 'I would like to send you a message'
      }
    end
    assert_response :success
  end

  test 'should get thanks' do
    get :thanks
    assert_response :success
  end
end
