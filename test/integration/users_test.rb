require "#{File.dirname(__FILE__)}/../test_helper"

class UsersTest < ActionController::IntegrationTest
  fixtures :users
  context "Unlogged in user" do
    should "be able to see user page without links" do
      get("users/tim")
      assert_response :success
      assert_doesnt_have_login_form
      assert_select 'h1', :text => /Tim Diggins/
      assert_have_new_project_link false
    end
  end
  
  context "Logged in user" do
    setup do
      login('alex')
    end
    
    should "be able to see user page without links" do
      get("users/tim")
      assert_response :success
      assert_doesnt_have_login_form
      assert_select 'h1', :text => /Tim Diggins/
      assert_have_new_project_link false
    end
    should "be able to see self with links" do
      get("users/alex")
      assert_response :success
      assert_doesnt_have_login_form
      assert_select 'h1', :text => /Alexander Kohlhofer/
      assert_have_new_project_link true
    end
    
  end
  
  def assert_have_new_project_link has_link
    assert_select '#new-project-link', :count=>has_link ? 1 : 0      
  end
end
