class Contribution < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  
  def validate  
    if project_id.nil?
      errors.add(:project_id, "is missing")
    end
    if user_id.nil?
      errors.add(:user_id, "is missing")
    end
  end

end
