require 'test_helper'

class NotificationMailerTest < ActionMailer::TestCase
  should "be able to create new email address email" do
    response = NotificationMailer.create_new_email_address(email_addresses(:tim_other_unactivated))
    assert_match /Tim Diggins/, response.body
  end

  should "be able to create invitation email" do
    response = NotificationMailer.create_invitation(email_addresses(:someone_new))
    assert_match /Someone New/, response.body
  end

  should "be able to create forgot_password email" do
    response = NotificationMailer.create_forgot_password(email_addresses(:alex_primary))
    assert_match /Alexander Kohlhofer/, response.body
  end

end
