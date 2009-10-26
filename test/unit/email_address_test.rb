require 'test_helper'

class EmailAddressTest < ActiveSupport::TestCase
  should "know activated emails" do
    assert email_addresses(:alex_primary).active?
    assert email_addresses(:alex_other).active?
    assert email_addresses(:tim_primary).active?
    assert !email_addresses(:tim_other_unactivated).active?
  end
  

  should "know name" do
    assert_equal "Tim Diggins", email_addresses(:tim_primary).name
    assert_equal "Tim Diggins", email_addresses(:tim_other_unactivated).name
    assert_equal "Someone New", email_addresses(:someone_new).name
    assert_equal "Someone New", email_addresses(:someone_new).name
    assert_equal "First Last", email_addresses(:someone_with_dot_in_email).name
  end
  
  
  should "just changing something should not create notification" do
    eml = email_addresses(:alex_primary)
    assert_no_difference('eml.notifications(true).size') do
      eml.user = users(:tim)
      eml.save!
    end
    
    eml = email_addresses(:tim_other_unactivated)
    assert_no_difference('eml.notifications(true).size') do
      eml.user = users(:alex)
      eml.save!
    end
  end
  
  should "can recreate notification" do
    eml = email_addresses(:alex_primary)
    assert_no_difference('eml.notifications(true).size') do
      eml.queue_notification
    end
    eml = email_addresses(:tim_other_unactivated)
    assert_difference('eml.notifications(true).size') do
      eml.queue_notification      
    end
  end
  
  should "create activation code with new email address" do
    floating_new_email = EmailAddress.create(:email=>'some@somewhere.com')
    assert !floating_new_email.activation_code.blank?
    alex_new_email = users(:alex).email_addresses.create(:email=>'somewhereelse@somewhere.com')
    assert !alex_new_email.activation_code.blank?
  end
  
  should "create email address for user with notification" do    
    alex_new_email = users(:alex).email_addresses.build(:email=>'somewhereelse@somewhere.com')
    alex_new_email.save!
    assert_equal 1, alex_new_email.notifications.size
    assert_notification_action_equals 'added_email_address', alex_new_email.notifications[0].action 
  end

  
  
end
