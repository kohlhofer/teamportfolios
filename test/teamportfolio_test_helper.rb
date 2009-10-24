module TeamportfolioTestHelper
  def assert_notification_action_equals expected_action, action
    assert_equal expected_action, action  
    assert (NotificationMailer.respond_to? "create_#{expected_action}".to_sym)   
    assert (NotificationMailer.respond_to? "deliver_#{expected_action}".to_sym)   
  end
  
    def recount_stuff!
    User.reset_column_information
    User.find(:all).each do |u|
      User.update_counters u.id, :projects_count => u.projects.length
    end
  end

end