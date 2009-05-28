require "#{File.dirname(__FILE__)}/../test_helper"

class ProjectsTest < ActionController::IntegrationTest
  fixtures :projects, :users
  context "Unlogged in user" do
    
    should "be able to see  individual project page" do
      get("projects/weewar")
      view
      assert_response :success
      assert_doesnt_have_login_form
      assert_select 'a[href=http://weewar.com]', :count => 1
    end
    
    should "be able to see projects listing" do
      get("projects")
      assert_response :success
      assert_doesnt_have_login_form
      assert_select '#projects div.project-preview', :count => 5
    end
    
  end
  
  context "Logged in user" do
    setup do
      login('alex')
    end
    
    should "be able to see own projects" do
      get("users/alex")
      assert_response :success
      assert_doesnt_have_login_form
      assert_select '#projects div.project-preview', :count => 3
    end
    
    should "be able to create new project page" do
      get 'users/alex'
      click_link "new-project-link"
      assert_response_ok
      fill_in :title, :with => 'My Lovely New Project'
      fill_in :description, :with => 'Some nice body text'
      fill_in :homepage, :with => 'http://somehomepage.com'
      click_button
      assert_redirected_to 'http://teamportfolios.dev/projects/my_lovely_new_project'
      follow_redirect!
      assert_select 'h1', :text=>/.*My Lovely New Project.*/
      assert_select "a[href='http://somehomepage.com']", 'http://somehomepage.com'
      assert_am_contributor_to_this_project
    end
    
  end 
  
  
  context "User contributing to project" do
    
    setup do
      login 'alex'
      get 'projects/weewar'
    end
    
    should "be able to edit it" do
      click_link "edit-project-link"
      put_via_redirect "/projects/weewar", :project => { :title => "Fandango" }
      assert_response :success
      assert_doesnt_have_login_form
      assert_select 'h1', :text => /Fandango/
    end
    
    should "be able to add other contributor by name only" do
      assert_select 'form#add-contributor', :count=>1
      fill_in 'unvalidated_contributor[name]', :with => 'Some Random Name' 
      click_button
      follow_redirect!
      assert_select 'li.not-validated', /.*Some Random Name.*/
    end
  end
  
  def assert_not_able_to_edit_project
    assert_select 'a#edit-project-link', :count=>0
    post_via_redirect request.url, :project => {:title => 'GilgameshProj'}
    assert_response 405
  end
  
  def assert_not_able_to_add_contributor_to_project
    assert_select 'form#add-contributor', :count=>0
    post "projects/cleverplugs/unvalidated_contributors", :params=>{:unvalidated_contributor=>{:name=>'Some Random Name or Other'}}
    assert_response :forbidden
  end
  def assert_no_validation_link
    assert_select 'form#validate-self-as-contributor', :count=>0
    post "projects/cleverplugs/unvalidated_contributors", :params=>{:unvalidated_contributor=>{:name=>'Some Random Name or Other'}}
    assert_response 405
  end
  
  context "User who is unvalidated contributor to project" do
    
    setup do
      login 'alex'
      get 'projects/treesforcities'
    end
    
    should "be able to validate self as contributor" do
      assert_select 'form#validate-self-as-contributor', :count=>1
      submit_form 'validate-self-as-contributor'
      follow_redirect!
      assert_am_contributor_to_this_project
    end
    
    should "not be able to edit it" do
      assert_not_able_to_edit_project
    end
    
    should "should not be able to add contributor" do
      assert_not_able_to_add_contributor_to_project
    end
    
  end
  
  context "User not contributing to project" do
    
    setup do
      login 'alex'
      get 'projects/cleverplugs'
    end
    
    should "not be able to edit it" do
      assert_not_able_to_edit_project
    end
    
    should "should not be able to add contributor" do
      assert_not_able_to_add_contributor_to_project
    end
    
  end
  
  def assert_am_contributor_to_this_project
    assert_select "ul#contributors" do 
      assert_select"a[href='/users/alex']"
    end
  end
end
