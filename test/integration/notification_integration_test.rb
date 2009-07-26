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
#      view_mail email
      assert_match /Duff O'Melia/, email.body
      assert_match /added/, email.subject
      assert_match /WeeWar/, email.body
    end
  end
  
  def view_mail email
    filename = File.dirname(__FILE__) + "/../../public/.integration_test_email.text"
    flunk("There was no response to view") unless email
    File.open(filename, "w+") { | file | file.write(email) }
    `open #{filename}`
  end
  
end
