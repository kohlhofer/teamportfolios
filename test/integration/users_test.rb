require "#{File.dirname(__FILE__)}/../test_helper"

class UsersTest < ActionController::IntegrationTest
  fixtures :users
  
  def assert_sees_user_page
    assert_response :success
    assert_doesnt_have_login_form
    assert_select 'h1', :text => /Tim Diggins/
    assert_select 'a[href=http://tim.homepage.com]', :text=>'homepage', :count => 1
    assert_have_new_project_link false
  end
  context "Unlogged in user" do
    should "be able to see user page" do
      get("users/tim")
      assert_sees_user_page
    end
    
    should "be able to get 404 fer unknown user page" do
      get("users/someunknownuser")
      assert_response_404
    end
    
    should "be able to see subdomain page" do
      get("http://tim.teamportfolios.dev")
      assert_sees_user_page
    end
    
    should "be able to get 404 fer unknown subdomain page" do
      get("http://someunknownuser.teamportfolios.dev")
      assert_response_404
    end
    
    should "be get error message if no activation code found" do
      get_ok('join')
      fill_in :email, :with=>'someone_new@elsewhere.com'
      click_button
      assert_response_ok
      assert_select '#errorExplanation', :text=>/Activation code/
      view
    end
    
    should "be able to see join page and sign up" do
      get_ok('join')
      fill_in :email, :with=>'someone_new@elsewhere.com'
      fill_in :activation_code, :with=>'somenewrandomhash'
      click_button
      assert_response_ok
      fill_in :password, :with=>'somepass'
      fill_in 'user[password_confirmation]', :with=>'somepass'
      click_button
      assert_response_ok
      assert !User.find_by_login('someone_new').nil?
    end
    
    should "expect join page to give error if password too short" do
      get_ok('join')
      fill_in :email, :with=>'someone_new@elsewhere.com'
      fill_in :activation_code, :with=>'somenewrandomhash'
      click_button
      assert_response_ok
      fill_in :password, :with=>'sh' #too short
      fill_in 'user[password_confirmation]', :with=>'sh'
      click_button
      assert_response_ok
      assert User.find_by_login('someone_new').nil?
      view :too_short
      assert_select 'li', :text=>/too short/
    end
    
    should "be able to see a list of users" do
      get_ok("users")
      %w{bert duff tim alex}.each do |user|
        assert_select "a[href=http://#{user}.teamportfolios.dev/]", :min=>1
      end
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
      get("http://alex.teamportfolios.dev")
      assert_response :success
      assert_doesnt_have_login_form
      assert_select 'h1', :text => /Alexander Kohlhofer/
      assert_have_new_project_link true
    end
    
  end
  context "Logged in user on their own page" do
    setup do
      login('alex')
      get_ok 'http://alex.teamportfolios.dev'
      
    end
    
    should "be able to edit profile details" do
      assert_select "a[href=http://teamportfolios.dev/settings/profile]", :count=>1      
    end
    should "be able to add link" do
      assert_select "form#add-link-form", :count=>1
      fill_in 'user_link[label]', :with=> 'blog'
      fill_in 'user_link[url]', :with=>'http://blog.alex.com'
      click_button
      follow_redirect! while redirect?
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
      delete link_path
      assert_response_ok
      get "projects/alex"
      assert_select 'a.delete-link', :count=>0
    end
  end
  
  context "Logged in user on others page" do
    setup do
      login('tim')
      get 'http://alex.teamportfolios.dev'
    end
    
    should "not be able to edit profile details" do
      assert_select "a[href=/settings/profile]", :count=>0      
    end
    
    should "not be able to add link" do
      assert_select "form#add-link-form", :count=>0
      put link_path, :user_link=>{:url=>'somewhere', :label=>'something'}
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
    polymorphic_url([users(:alex), user_links(:alex_homepage)], :subdomain=>false)
  end
  def edit_link_path
    edit_polymorphic_url([users(:alex), user_links(:alex_homepage)], :subdomain=>false)
  end
  def new_link_path
    new_project_project_link_url(users(:alex), :subdomain=>false)
  end
  
  def assert_have_new_project_link has_link
    assert_select '#new-project-link', :count=>has_link ? 1 : 0      
  end
end
