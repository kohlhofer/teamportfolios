require "#{File.dirname(__FILE__)}/../test_helper"

class NotificationIntegrationTest < ActionController::IntegrationTest
  include ProjectTestHelper
  context "EmailNotificationSystem" do
    setup do
      @emails = ActionMailer::Base.deliveries
      @emails.clear
    end
    
    should "be able to add uvc and have invitation sent" do
      login 'alex'
      get 'projects/weewar'
      @project = projects(:weewar)
      add_contributor 'some guy', 'someguy@somewhere.com'
      
      Notification.process_queue
      
      assert_equal(1, @emails.size)
      email = @emails.first
      preview_mail :invitation
      
      assert_equal 'someguy@somewhere.com', email.to[0]
      assert_match /some guy/, email.body
      assert_match /invitation/, email.subject
      assert_match /WeeWar/, email.body
    end
    
    should "be able to add existing user and have notification sent" do
      login 'alex'
      get 'projects/weewar'
      @project = projects(:weewar)
      add_contributor 'duff', 'duff@teamportfolios.com'
      
      Notification.process_queue
      
      assert_equal(1, @emails.size)
      email = @emails.first
      assert_equal 'duff@teamportfolios.com', email.to[0]
      preview_mail :addexistinguser
      assert_match /Duff O'Melia/, email.body
      assert_match /added/, email.subject
      assert_match /WeeWar/, email.body
    end
    
    should "be able to request password change" do
      get_ok '/login/forgot_password'
      fill_in 'email', :with=>'alex@teamportfolios.com'
      click_button
      follow_redirect! while redirect?
      
      Notification.process_queue
      
      assert_equal(1, @emails.size)
      email = @emails.first
      assert_equal 'alex@teamportfolios.com', email.to[0]
      preview_mail :forgot_password
      assert_match %r{http://[a-z.]+#{reset_password_path_for('alex')}}, email.body
      assert_match /Forgot your password/, email.subject
      assert_match /reset your password/, email.body
    end
    
  end
  
  
end
