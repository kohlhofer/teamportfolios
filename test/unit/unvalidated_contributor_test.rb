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

  should "create invitation notification when created for user" do
    berts_email = users(:bert).primary_email
    assert_equal 0, berts_email.notifications.size
    uvc = projects(:cleverplugs).unvalidated_contributors.build()
    uvc.email_address = berts_email
    uvc.save!
    assert_equal 1, berts_email.notifications(true).size
    assert_notification_action_equals 'added_to_project', berts_email.notifications[0].action
  end
end
