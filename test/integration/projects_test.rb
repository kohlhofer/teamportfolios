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
      assert_select 'a[href=http://weewar.com]', :count => 1
    end
    
    should "be able to create new project page" do
      login("alex")
      click_link "new-project-link"
      assert_response_ok
      fill_in :title, :with => 'My Lovely New Project'
      fill_in :description, :with => 'Some nice body text'
      fill_in :homepage, :with => 'http://somehomepage.com'
      click_button
      assert_redirected_to 'http://teamportfolios.dev/projects/my_lovely_new_project'
      follow_redirect!
      view
      assert_select 'h1', "My Lovely New Project"
      assert_select "a[href='http://somehomepage.com']", 'http://somehomepage.com'
      assert_select "ul#contributors" do 
        assert_select"a[href='/users/alex']"
      end
      
    end
    
    should "be able to edit collaborating project page" do
      login('alex')
      put_via_redirect "/projects/weewar", :user => { :name => "Fandango" }
      assert_response :success
      assert_doesnt_have_login_form
      assert_select 'h1', :text => /Fandango/
    end
    
    should "should not be able to edit non-collaborating project page" do
      login('alex')
      put_via_redirect "/projects/cleverplugs", :user => { :name => "Golgomesh" }
      assert_response :success
      assert_doesnt_have_login_form
      assert_select 'h1', :text => /Alexander Kohlhofer/
    end
    
  end
  
end
