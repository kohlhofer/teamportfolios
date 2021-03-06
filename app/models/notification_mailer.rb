class NotificationMailer < ActionMailer::Base
  include Exceptions  
  
  def invitation(email_address)
    setup_email email_address
    
    subject 'An invitation to join Team Portfolios'
    body ({:email=> email_address})
  end
  
  def added_to_project(email_address)
    setup_email email_address
    
    uvcs = email_address.unvalidated_contributors
    if uvcs.size>1
      subject "Team Portfolios: You have been added to #{uvcs.size} projects"
    elsif uvcs.size==1
      subject "Team Portfolios: You have been added to #{uvcs[0].project.title}"
    else
      raise MailNoLongerNeeded.new('Expecting at least 1 unvalidated contribution')
    end
    body ({:email=> email_address})
  end
  
  def added_email_address(email_address)
    setup_email email_address
    
    subject 'Team Portfolios: Please confirm your email address'
    body ({:user=> email_address.user, :activation_code=> email_address.activation_code})
  end
  
  def forgot_password(email_address)
    setup_email email_address
    
    subject 'Team Portfolios: Forgot your password?'
    user = email_address.user
    body ({:user=> user, :reset_password_code=> user.reset_password_code})
  end
  
  protected
  def setup_email email_address
    recipients email_address.email
    from 'do-not-reply@teamportfolios.com'
    bcc ['tim@red56.co.uk']
  end
  
end
