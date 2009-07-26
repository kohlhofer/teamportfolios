class Notification < ActiveRecord::Base
  belongs_to :email_address
  
  def self.process_queue
    self.all.each do |notification| 
      notification.process 
    end    
  end
  
  def process
    NotificationMailer.send("deliver_#{self.action}".to_sym, self.email_address)     
  end
end
