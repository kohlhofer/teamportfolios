class Notification < ActiveRecord::Base
  belongs_to :email_address
  
  def self.process_queue
    self.all.each do |notification| 
      notification.process 
    end    
  end
  
  def process
    begin
      NotificationMailer.send("deliver_#{self.action}".to_sym, self.email_address)
    rescue Exception => e
      self.attempted_send = Time.now
      self.failure_msg = e.to_s
      puts "# Attempted to send '#{self.action}' to #{self.email_address.email}"
      puts "#           but '#{e}'"
      save
      return
    end 
    puts "# sent '#{self.action}' to #{self.email_address.email}"
    self.destroy
  end
end
