require "#{File.dirname(__FILE__)}/../test_helper"

class UsersTest < ActionController::IntegrationTest
  fixtures :users
  context "Unlogged in user" do
    should "be able to see user page" do
      get("users/tim")
      assert_response :success
      assert_doesnt_have_login_form
      assert_select 'h1', :text => /Tim Diggins/
      assert_select 'a[href=http://tim.homepage.com]', :text=>'homepage', :count => 1
      assert_have_new_project_link false
    end
  end
  
  context "Logged in user" do
    setup do
      login('alex')
    end
    
    should "be able to see other user page without links" do
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
  context "Logged in user on their own page" do
    setup do
      login('alex')
      get_ok 'users/alex'
    end
    
    should "be able to edit profile details" do
      assert_select "a[href=/settings/profile]", :count=>1      
    end
    should "be able to add link" do
      assert_select "form#add-link-form", :count=>1
      fill_in 'user_link[label]', :with=> 'blog'
      fill_in 'user_link[url]', :with=>'http://blog.alex.com'
      click_button
      follow_redirect!
      assert_select 'a[href=http://blog.alex.com]', :text=> 'blog', :count=>1
      assert_select 'a[href=http://alex.homepage.com]', :text=> 'homepage', :count=>1
    end
    
    should "be able to edit link" do
      assert_select "a.edit-link[href=#{edit_link_path}]", :count=>1
      get_ok edit_link_path
      fill_in 'user_link[url]', :with=>'http://better_link_for_alex.com'
      fill_in 'user_link[label]', :with=> 'lovelyhome'
      click_button 
      follow_redirect!
      assert_select 'a[href=http://better_link_for_alex.com]', :text=> 'lovelyhome', :count=>1
    end
    
    should "be able to remove link" do
      assert_select 'a.delete-link', :count=>1
      p "delete #{link_path}"
      delete link_path
      assert_response_ok
      get "projects/alex"
      assert_select 'a.delete-link', :count=>0
    end
  end
  
  context "Logged in user on others page" do
    setup do
      login('tim')
      get 'users/alex'
    end
    
    should "not be able to edit profile details" do
      assert_select "a[href=/settings/profile]", :count=>0      
    end
    
    should "not be able to add link" do
      assert_select "form#add-link-form", :count=>0
      put link_path, :user_link=>{:url=>'somewhere', :label=>'something'}
      view
      assert_response :forbidden
    end
    
    should "not be able to edit link" do
      assert_select "a.edit-link[href=#{edit_link_path}]", :count=>0
      get edit_link_path
      assert_response :forbidden
    end
    
    should "not be able to remove link" do
      assert_select 'a.delete-link', :count=>0
      delete_via_redirect link_path
      assert_response :forbidden
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
