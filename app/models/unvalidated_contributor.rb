class UnvalidatedContributor < ActiveRecord::Base
  belongs_to :project
  belongs_to :email_address
  belongs_to :user
  
  alias_attribute :to_s, :name
  accepts_nested_attributes_for :email_address
  
  def validate  
    if project_id.nil?
      errors.add(:project_id, "is missing")
    end
  end
  
#  def name
#    if !self.email_address.nil? && !self.email_address.user.nil? 
#      self.email_address.user.name 
#    else
#      read_attribute :login
#    end
#  end
end
