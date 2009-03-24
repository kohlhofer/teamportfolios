require "#{File.dirname(__FILE__)}/../test_helper"

class LoginAndOutTest < ActionController::IntegrationTest
  fixtures :users
  context "normally" do
    should "be able to login and out" do
      get("/")
      follow_redirect!
      assert_response :success
      assert_has_login_form
      
      login('alex')
      get("/")
      assert_doesnt_have_login_form      
      assert_select "a[href=/logout]"
      assert_select "a[href='/users/alex']"
    end
    
  end
  
end