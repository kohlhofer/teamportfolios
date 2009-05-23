class Project < ActiveRecord::Base
  alias_attribute :to_s, :name
  alias_attribute :to_param, :name
  
  validates_presence_of :title
  
  has_many :contributions, :dependent => :destroy
  has_many :contributors, :through => :contributions, :source => :user, :uniq => true

  before_create do |project|
    name = project.title 
    name = name.downcase
    name = name.gsub(/([ _-]+$|^[ _-]+)/, '')
    name = name.gsub(/[ _-]+/, '_')
    name = name.gsub(/([^a-z0-9 _]|-)+/, '')
    project.name = name 
  end

end
