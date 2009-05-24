class UnvalidatedContributor < ActiveRecord::Base
  belongs_to :project

  alias_attribute :to_s, :name

  def validate  
    if project_id.nil?
      errors.add(:project_id, "is missing")
    end
  end
end
