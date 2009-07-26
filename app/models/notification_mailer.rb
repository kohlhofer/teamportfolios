class NotificationMailer < ActionMailer::Base
  
  
  def invitation(email_address)
    fromto email_address
    
    subject    'An invitation to join Team Portfolios'
    body ({:email=> email_address})
  end
  
  def new_email_address(email_address)
    fromto email_address
    
    subject 'Team Portfolios: Please confirm your email address'
    body ({:user=> email_address.user, :activation_code=> email_address.activation_code})
  end
  
  def forgot_password(email_address)
    fromto email_address
    
    subject 'Team Portfolios: Forgot password?'
    body ({:user=> email_address.user, :activation_code=> email_address.activation_code})
  end
  
  protected
  def fromto email_address
    recipients email_address.email
    from 'notifications@teamportfolios.com'
  end
  
end
