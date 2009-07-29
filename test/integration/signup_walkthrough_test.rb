require "#{File.dirname(__FILE__)}/../test_helper"

class SignupWalkthroughTest < ActionController::IntegrationTest
  include ProjectTestHelper
  
  context "Signup" do
    setup do
      @emails = ActionMailer::Base.deliveries
      @emails.clear
    end
    
    should "work" do
      login 'alex'
      get 'projects/weewar'
      @project = projects(:weewar)
      add_contributor 'some guy', 'someguy@somewhere.com'
      
      Notification.process_queue
      
      assert_equal(1, @emails.size)
      email = @emails.first
      
      assert_equal 'someguy@somewhere.com', email.to[0]
      code = EmailAddress.find_by_email('someguy@somewhere.com').activation_code
      expecting_url = "http://teamportfolios.com/join?activation_code=#{code}&email=someguy@somewhere.com"
      assert_match expecting_url, email.body
      get expecting_url
      fill_in :password, :with=> 'mypass'
      fill_in 'user[password_confirmation]', :with=> 'mypass'
      click_button
      follow_redirect!
      assert_response_ok
      
    end
  end
  
end
