require "#{File.dirname(__FILE__)}/../test_helper"

class ProjectsTest < ActionController::IntegrationTest
  fixtures :projects, :users
  context "Unlogged in user" do
    should "not be able to see anything without logging in" do
      get("projects")
      assert_response :redirect
      follow_redirect!
      assert_has_login_form
    end
  end
  
  context "Logged in user" do
    should "be able to see projects page" do
      login('alex')
      get("projects")
      assert_response :success
      assert_doesnt_have_login_form
      assert_select 'ul#projects li', :count => 3
    end
    
    should "be able to see  individual project page" do
      login('alex')
      get("projects/weewar")
      assert_response :success
      assert_doesnt_have_login_form
      view
      assert_select 'a[href=http://weewar.com]', :count => 1
    end
  end
  
end
