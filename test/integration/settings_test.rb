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
      assert_select 'form' do
        assert_select 'input', :text=>/Alexander Kohlhofer/, :count=>1
        assert_select 'input', :text=>/alex@teamportfolios.com/, :count=>1
      end
    end
    should "should be able to edit settings" do
      put_via_redirect "/settings", :user => { :name => "Fandango" }
      assert_response :success
      assert_select 'h1', :text => /Fandango/
    end
    
  end
  
end
