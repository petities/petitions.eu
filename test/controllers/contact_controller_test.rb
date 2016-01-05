require 'test_helper'

class ContactControllerTest < ActionController::TestCase
  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should post create and get redirected' do
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      post :create, contact_form: {
        name: 'Example Name',
        mail: 'name@example.com',
        message: 'I would like to send you a message'
      }
    end
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
