class Notification < ActiveRecord::Base
  belongs_to :email_address
  
end
