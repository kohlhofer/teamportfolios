require "#{File.dirname(__FILE__)}/../test_helper"

class DashboardPageTest < ActionController::IntegrationTest
  fixtures :users
  context "Unlogged in user" do
    should "not be able to see dashboard page" do
      get("dashboard")
      assert_redirected_to new_session_path 
    end
  end
  
  context "Logged in user" do
    setup do
      login('alex')
    end
    
    should "be able to see dashboard page" do
      get_ok("dashboard")
      assert_have_new_project_link true
    end
    
  end
  
  protected
  
  def link_path
    polymorphic_path([users(:alex), user_links(:alex_homepage)])
  end
  def edit_link_path
    edit_polymorphic_path([users(:alex), user_links(:alex_homepage)])
  end
  def new_link_path
    new_project_project_link_path(users(:alex))
  end
  
  def assert_have_new_project_link has_link
    assert_select '#new-project-link', :count=>has_link ? 1 : 0      
  end
end
