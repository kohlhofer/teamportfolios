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
      @logged_in_user_id = users(:alex).id
    end
    
    
    should "should be able to view and submit settings form" do
      
      get "/settings"
      new_settings = {
        #        :login => "manglewurzler",
        :name => "Mangle Wurzler",
        :email => 'mw@implements.com',
        :strapline => 'my lovely strapline',
        :password => 'neupasswort',
        :password_confirmation => 'neupasswort'
      }
      
      
      
      get '/settings'
      assert_response :success
      
      new_settings.each {|key,value| fill_in "user[%s]" % key, :with=>value}
      click_button
      follow_redirect!
      assert_response :success
      assert_select 'h1', :text => /Mangle Wurzler/
      
      user = User.find_by_id(@logged_in_user_id)
      
      new_settings.each do |attribute,value|
        unless (attribute==:password_confirmation || attribute==:password)
          assert_equal value, user.send(attribute) 
        end
      end  
    end
    
    should "should be able to edit settings" do
      put_via_redirect "/settings", :user => { :name => "Fandango" }
      assert_response :success
      assert_select 'h1', :text => /Fandango/
    end
    
  end
  
end
