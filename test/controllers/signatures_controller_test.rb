require 'test_helper'

class SignaturesControllerTest < ActionController::TestCase
  setup do
    @petition = petitions(:one)
    @signature = signatures(:one)
    @newsignature = new_signatures(:one)
  end

  #test "should get index" do
  #  get :index
  #  assert_response :success
  #  assert_not_nil assigns(:signatures)
  #end

  #test "should get new" do
  #  get :new, :petition_id => 1
  #  assert_response :success
  #end

  test "should create signature" do
    assert_difference('NewSignature.count') do
      post :create, :petition_id=>@petition, signature: {
        #:petition_id => @petitions.id,
        :person_name => 'test name',
        :person_email => 'test2@gmail.com',
        :person_city => 'test city',
        :visible => true,
        :special => true,
        :subscribe => true,
        :created_at => Time.now,
        :updated_at => Time.now,
        :signed_at => Time.now, 
        :confirmed_at => Time.now, 
        :confirmed => false,
      }
    end
    assert_redirected_to petition_path(@petition)
  end


  test "signature confirmation links" do
    assert_routing("/signatures/10/confirm", :controller => "signatures", 
                   :action => "confirm", :signature_key => "10")

    assert_routing("/signatures/xx/confirm", :controller => "signatures", 
                   :action => "confirm", :signature_key => "xx")
  end

  test "check confirmation logic" do
    assert_difference('Signature.count') do 
      get :confirm, :signature_key => @newsignature.unique_key
      assert_redirected_to @petition 
    end
    # when we do it again nothing should happen.
    assert_no_difference('Signature.count') do 
      get :confirm, :signature_key => @newsignature.unique_key
    end
  end

 
  #test "should show signature" do
  #  get :show, id: @signature
  #  assert_response :success
  #end

  #test "should get edit" do
  #  get :edit, id: @signature
  #  assert_response :success
  #end

  #test "should update signature" do
  #  patch :update, id: @signature, signature: {  }
  #  #assert_redirected_to signature_path(assigns(:signature))
  #  assert_redirected_to petition_path(@petition)
  #end

  #test "should destroy signature" do
  #  assert_difference('Signature.count', -1) do
  #    delete :destroy, id: @signature
  #  end

  #  assert_redirected_to signatures_path
  #end
end
