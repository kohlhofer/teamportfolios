require "#{File.dirname(__FILE__)}/../test_helper"

class UsersTest < ActionController::IntegrationTest
  fixtures :users
  context "Unlogged in user" do
    should "not be able to see anything without logging in" do
      get("users/alex")
      assert_response :redirect
      follow_redirect!
      assert_has_login_form
    end
  end
  
  context "Logged in user" do
    setup do
        login('alex')
    end

    should "be able to see user page" do
      get("users/tim")
      assert_response :success
      assert_doesnt_have_login_form
      assert_select 'h1', :text => /Tim Diggins/
    end
    
  end
  
end
