require "#{File.dirname(__FILE__)}/../test_helper"

class ProjectsTest < ActionController::IntegrationTest
  fixtures :projects, :users
  context "Unlogged in user" do
    
    should "be able to see  individual project page" do
      get("projects/weewar")
      assert_response :success
      assert_doesnt_have_login_form
      assert_select 'a[href=http://weewar.com]', :text=>'homepage', :count => 1
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
      fill_in :url, :with => 'http://somehomepage.com'
      click_button
      assert_redirected_to 'http://teamportfolios.dev/projects/my_lovely_new_project'
      follow_redirect!
      assert_select 'h1', :text=>/.*My Lovely New Project.*/
      assert_select "a[href='http://somehomepage.com']", 'homepage'
      assert_am_contributor_to_this_project
    end
    
  end 
  
  
  context "User contributing to project" do
    
    setup do
      login 'alex'
      get 'projects/weewar'
      @project = projects(:weewar)
    end
    
    should "be able to edit it" do
      click_link "edit-project-link"
      put_via_redirect "/projects/#{@project.name}", :project => { :title => "Fandango" }
      assert_response :success
      assert_doesnt_have_login_form
      assert_select 'h1', :text => /Fandango/
    end
    
    should "be able to see it hidden" do
      assert_select "a[href=/projects/#{@project.name}/edit]", :count=>1
      get "projects/#{@project.name}?hide_admin=true"
      assert_select "a[href=/projects/#{@project.name}/edit]", :count=>0
    end
    
    should "be able to add other contributor by name only" do
      assert_select 'form#add-contributor', :count=>1
      fill_in 'unvalidated_contributor[name]', :with => 'Some Random Name'
      submit_form "add-contributor" 
      follow_redirect!
      assert_response_ok
      assert_select 'li.not-validated', /.*Some Random Name.*/
    end
    
    should "be able to add other contributor by name and new email" do
      assert_select 'form#add-contributor', :count=>1
      fill_in 'unvalidated_contributor[name]', :with => 'Some Random Name'
      fill_in 'email', :with => 'newemail@addr.com'
      submit_form "add-contributor" 
      follow_redirect!
      assert_response_ok
      assert_select 'li.not-validated', /.*Some Random Name.*/
    end
    
    should "be able to add other contributor by name and  email of existing user" do
      assert_select 'form#add-contributor', :count=>1
      fill_in 'unvalidated_contributor[name]', :with => 'tim@teamportfolios.com'
      submit_form "add-contributor" 
      follow_redirect!
      assert_response_ok
      assert_select 'li.not-validated', /.*Tim Diggins.*/
    end
    
    should "be able to remove unvalidated contributor" do
      assert_select 'li.not-validated',  :count=>2
      assert_select 'li.not-validated', /.*Tim Diggins.*/ do |elem|
        assert_select 'a.delete-unvalidated'
      end
      delete_via_redirect project_unvalidated_contributor_path(@project, example_unvalidated_contributor)
      assert_select 'li.not-validated',  :count=>1
    end
    
    should "be able to edit unvalidated contributors email" do
      assert_select 'li.not-validated', /.*#{example_unvalidated_contributor_name}.*/ do |elem|
        assert_select 'a.edit-unvalidated'
      end
      get edit_project_unvalidated_contributor_path(@project, example_unvalidated_contributor)
      assert_response_ok
      fill_in 'email', :with=> "someoneelse@mail.com"
      fill_in 'name', :with=> "Shnoggle"
      click_button
      follow_redirect!
      assert_select 'li.not-validated', /.*Shnoggle.*/ 
    end
    
    should "be able to leave project" do
      logout
      login(:bert)
      get("projects/#{@project.name}")
      assert_select 'a#leave-project'
      assert_select 'a#delete-project', :count=>0
      put leave_project_path(@project)
      assert_response_ok
      get "projects/#{@project.name}"
      assert_select 'a#leave-project', :count=>0
      
      logout
      login(:alex)
      get("projects/#{@project.name}")
      assert_select 'a#leave-project', :count=>0
      assert_select 'a#delete-project'
      delete project_path(@project)
      assert_response_ok
      get "projects/#{@project.name}"
      assert_response 404
    end
    
    should "be able to add link" do
      assert_select "form#add-link-form", :count=>1
      fill_in 'project_link[label]', :with=> 'blog'
      fill_in 'project_link[url]', :with=>'http://blog.wee.com'
      click_button
      follow_redirect!
      assert_select 'a[href=http://blog.wee.com]', :text=> 'blog', :count=>1
      assert_select 'a[href=http://weewar.com]', :text=> 'homepage', :count=>1
    end
    
    should "be able to edit link" do
      assert_select "a.edit-link[href=#{edit_link_path}]", :count=>1
      get_ok edit_link_path
      fill_in 'project_link[url]', :with=>'http://better_link_for_weewar.com'
      fill_in 'project_link[label]', :with=> 'lovelyhome'
      click_button 
      follow_redirect!
      assert_select 'a[href=http://better_link_for_weewar.com]', :text=> 'lovelyhome', :count=>1
    end
    
    should "be able to remove link" do
      assert_select 'a.delete-link', :count=>1
      delete link_path
      assert_response_ok
      get "projects/#{@project.name}"
      assert_select 'a.delete-link', :count=>0
    end
  end
  
  def example_unvalidated_contributor    
    return unvalidated_contributors(:tim_is_unvalidated_contributor_of_weewar) if @project ==projects(:weewar)
    return unvalidated_contributors(:duff_is_unvalidated_contributor_of_cleverplugs) if @project ==projects(:cleverplugs)
    raise "unexpected project #@project"
  end
  def example_unvalidated_contributor_name    
    return "Tim Diggins" if @project ==projects(:weewar)
    return "Duff O'Melia" if @project ==projects(:cleverplugs)
    raise "unexpected project #@project"
  end
  def example_project_link    
    return project_links(:weewar_homepage) if @project ==projects(:weewar)
    return project_links(:cleverplugs_homepage) if @project==projects(:cleverplugs)
    return project_links(:treesforcities_homepage) if @project==projects(:treesforcities)
    raise "unexpected project #@project"
  end
  def link_path
    polymorphic_path([@project, example_project_link])
  end
  def edit_link_path
    edit_polymorphic_path([@project, example_project_link])
  end
  def new_link_path
    new_project_project_link_path(@project)
  end
  
  def assert_not_able_to_edit_project
    assert_select 'a#edit-project-link', :count=>0
    put_via_redirect request.url, :project => {:title => 'GilgameshProj'}
    assert_response :forbidden
  end
  
  def assert_not_able_to_edit_or_remove_unvalidated_contributor
    assert_select 'a.edit-unvalidated', :count=>0
    get edit_project_unvalidated_contributor_path(@project, example_unvalidated_contributor)
    assert_response :forbidden
    assert_select 'a.remove-unvalidated', :count=>0
    delete_via_redirect project_unvalidated_contributor_path(@project, example_unvalidated_contributor)
    assert_response :forbidden
  end
  
  def assert_not_able_to_leave_project
    assert_select 'a#leave-project', :count=>0
    put leave_project_path(@project)
    assert_response :forbidden
    assert_select 'a#delete-project', :count=>0
    delete project_path(@project)
    assert_response :forbidden
  end
  
  def assert_not_able_to_add_contributor_to_project
    assert_select 'form#add-contributor', :count=>0
    post "projects/#{@project.name}/unvalidated_contributors", :params=>{:unvalidated_contributor=>{:name=>'Some Random Name or Other'}}
    assert_response :forbidden
  end
  
  def assert_not_able_to_validate_self_as_contributor 
    assert_select 'form#validate-self-as-contributor', :count=>0
    put "projects/#{@project.name}/unvalidated_contributors/validate_self"
    assert_response_forbidden 
  end
  
  context "User who is unvalidated contributor to project" do
    
    setup do
      login 'alex'
      get 'projects/treesforcities'
      @project = projects(:treesforcities)
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
    
    should "should not be able to leave project" do
      assert_not_able_to_leave_project 
    end
    
  end
  
  context "User not contributing to project" do
    
    setup do
      login 'alex'
      get 'projects/cleverplugs'
      @project = projects(:cleverplugs)
    end
    
    should "not be able to edit it" do
      assert_not_able_to_edit_project
    end
    
    should "should not be able to add contributor" do
      assert_not_able_to_add_contributor_to_project
    end
    
    should "not be able to edit or remove unvalidated contributor" do
      assert_not_able_to_edit_or_remove_unvalidated_contributor
    end
    
    should "should not be able to leave project" do
      assert_not_able_to_leave_project 
    end
    
    should "not be able to add link" do
      assert_select "form#add-link-form", :count=>0
      put polymorphic_path([@project, example_project_link]), :project_link=>{:url=>'somewhere', :label=>'something'}
      assert_response :forbidden
    end
    
    should "not be able to edit link" do
      assert_select "a.edit-link[href=#{edit_link_path}]", :count=>0
      get edit_polymorphic_path([@project, example_project_link])
      assert_response :forbidden
    end
    
    should "not be able to remove link" do
      assert_select 'a.delete-link', :count=>0
      delete_via_redirect polymorphic_path([projects(:cleverplugs), project_links(:cleverplugs_homepage)])
      assert_response :forbidden
    end
    
  end
  
  context "User who is unvalidated contributor to project via unactivated email" do
    
    setup do
      login 'bert'
      get 'projects/treesforcities'
      @project = projects(:treesforcities)
    end
    
    should "not be able to validate self as contributor" do
      assert_not_able_to_validate_self_as_contributor
    end
    
    should "not be able to edit it" do
      assert_not_able_to_edit_project
    end
    
    should "should not be able to add contributor" do
      assert_not_able_to_add_contributor_to_project
    end
    
    should "should not be able to leave project" do
      assert_not_able_to_leave_project 
    end
    
  end
  
  
  def assert_am_contributor_to_this_project
    assert_select "#contributors" do 
      assert_select"a[href='/users/alex']"
    end
  end
  
  def assert_response_forbidden
    assert [403,405].include?(response.response_code), "expected a response code of 403 or 405, not %s" % response.response_code
  end
end
