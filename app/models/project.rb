class Project < ActiveRecord::Base
  alias_attribute :to_s, :title
  alias_attribute :to_param, :name
  
  validates_presence_of :title
  
  has_many :contributions, :dependent => :destroy
  has_many :unvalidated_contributors, :dependent => :destroy
  has_many :contributors, :through => :contributions, :source => :user, :uniq => true
  has_many :images, :dependent => :destroy
  has_one :image
  has_many :links, :class_name => "ProjectLink"
  
  accepts_nested_attributes_for :links, :reject_if => proc { |attrs| attrs.all? { |k, v| k!='url' || v.blank? || v=='http://' } }

  named_scope :random12, :limit => 11, :order => "RAND()" 
  named_scope :having_image, :include => :image, :conditions => [ "description <> '' AND images.filename <> ''"]



  before_create do |project|
    name = project.title 
    name = name.downcase
    name = name.gsub(/([ _-]+$|^[ _-]+)/, '')
    name = name.gsub(/[ _-]+/, '_')
    name = name.gsub(/([^a-z0-9 _]|-)+/, '')
    project.name = name 
  end

  def image
    images.first
  end
end
