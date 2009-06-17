require "#{File.dirname(__FILE__)}/../test_helper"

class LoginAndOutTest < ActionController::IntegrationTest
  fixtures :users
  context "normally" do
    should "be able to login and out" do
      get("/")
      assert_response :success
      
      login('alex')
      assert_response :success
      assert_doesnt_have_login_form      
      get("/")
      assert_doesnt_have_login_form      
      assert_select "a[href=/logout]"
      assert_select "a[href='/users/alex']"
    end
    
  end
  
end