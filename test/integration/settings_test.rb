require "#{File.dirname(__FILE__)}/../test_helper"

class SettingsTest < ActionController::IntegrationTest
  fixtures :users
  context "Unlogged in user" do
    should "not be able to see settings without logging in" do
      get("/settings")
      assert_response :redirect
      follow_redirect!
      assert_has_login_form
    end
  end
  
  context "Logged in user" do
    setup do
      login('alex')
    end
    
    should "should be able to view settings form" do
      get "/settings"
      assert_response :success
      select_form do
        assert_select 'input#user_login[value=alex]', :count=>1
        assert_select 'input#user_name[value=Alexander Kohlhofer]', :count=>1
        assert_select 'input#user_email[value=alex@teamportfolios.com]', :count=>1
        assert_select 'input#user_password', :count=>1
        assert_select 'input#user_password_confirmation', :count=>1
      end
    end
    
    should "should be able to view and submit settings form" do
      
      get "/settings"
      new_settings = {
        :login => "manglewurzler",
        :name => "Mangle Wurzler",
        :email => 'mw@implements.com',
        :password => 'neupasswort',
        :password_confirmation => 'neupasswort'
      }
      
      
      get '/settings'
      assert_response :success
      
      submit_form do |form|
        form.user.update(new_settings)
      end
      assert_response :success
      assert_select 'h1', :text => /Mangle Wurzler/
      
      user = assigns(:new_settings)
      
      assert_kind_of User, user
      assert_valid user
      
      new_settings.each do |attribute,expects|
        assert_equal expects, user.send(attribute)
      end
      
    end
    
    should "should be able to edit settings" do
      put_via_redirect "/settings", :user => { :name => "Fandango" }
      assert_response :success
      assert_select 'h1', :text => /Fandango/
    end
    
  end
  
end
