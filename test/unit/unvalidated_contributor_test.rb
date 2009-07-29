require 'test_helper'

class UnvalidatedContributorTest < ActiveSupport::TestCase
  
  should "create invitation notification when created" do
    someone_new = email_addresses(:someone_new)
    assert_equal 0, someone_new.notifications.size
    uvc = projects(:cleverplugs).unvalidated_contributors.build()
    uvc.email_address = someone_new
    uvc.save!
    assert_equal 1, someone_new.notifications(true).size
    assert_notification_action_equals 'invitation', someone_new.notifications[0].action
  end
  
  should "create invitation notification when created 4 user" do
    berts_email = users(:bert).primary_email
    assert_equal 0, berts_email.notifications.size
    uvc = projects(:cleverplugs).unvalidated_contributors.build()
    uvc.email_address = berts_email
    uvc.save!
    assert_equal 1, berts_email.notifications(true).size
    assert_notification_action_equals 'added_to_project', berts_email.notifications[0].action
  end
  
  should "be able to spot orphaned email_address" do
    #has user, no uvcs 
    eml = email_addresses(:bert)
    assert !eml.user.nil?
    assert_equal 0,eml.unvalidated_contributors.size
    assert !eml.orphaned?, "expected #{eml} not to be orphaned"
    
    #no user, has uvcs
    eml = email_addresses(:someone_new)
    assert eml.user.nil?
    assert eml.unvalidated_contributors.size > 0
    assert !eml.orphaned?, "expected #{eml} not to be orphaned"
    
    #has user, has uvc
    eml = email_addresses(:alex_primary)
    assert !eml.user.nil?
    assert eml.unvalidated_contributors.size > 0
    assert !eml.orphaned?, "expected #{eml} not to be orphaned"
    
    #no user, no uvcs
    eml = email_addresses(:aaron)
    assert eml.user.nil?
    assert_equal 0,eml.unvalidated_contributors.size
    assert eml.orphaned?, "expected #{eml} to be orphaned"
  end
  
  should "be able to purge orphaned email_addresses" do
    count = EmailAddress.all.size
    purged = EmailAddress.purge_orphaned!
    assert purged.size >0
    assert_equal count-purged.size,  EmailAddress.all.size
  end
end
