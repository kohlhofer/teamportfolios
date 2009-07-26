module TeamportfolioTestHelper
  def assert_notification_action_equals expected_action, action
    assert_equal expected_action, action  
    assert (NotificationMailer.respond_to? "create_#{expected_action}".to_sym)   
    assert (NotificationMailer.respond_to? "deliver_#{expected_action}".to_sym)   
  end
  
end