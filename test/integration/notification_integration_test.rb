require "#{File.dirname(__FILE__)}/../test_helper"

class NotificationIntegrationTest < ActionController::IntegrationTest
  include ProjectTestHelper
  @@preview_mail = false
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
  end
  
  def view_mail email_or_name_or_options
    email = name = nil
    if email_or_name_or_options.is_a? Hash
      email = email_or_name_or_options[:email]
      name = email_or_name_or_options[:name]
    elsif email_or_name_or_options.is_a?(String) || email_or_name_or_options.is_a?(Symbol)
      name = email_or_name_or_options
    else
      email =email_or_name_or_options
    end
    name = 'email' if name.nil?
    email = @emails.first if email.nil?
    filename = File.dirname(__FILE__) + "/../../public/.integration_test_#{name}.text"
    flunk("There was no response to view") unless email
    File.open(filename, "w+") { | file | file.write(email) }
    `open #{filename}`
  end
  
  def preview_mail email_or_name_or_options
    if @@preview_mail
      view_mail  email_or_name_or_options
    end
  end
  
end
