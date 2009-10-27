class EmailAddress < ActiveRecord::Base
  belongs_to :user
  has_many :unvalidated_contributors, :dependent => :nullify
  has_many :notifications, :dependent => :destroy
  
  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message
  
  alias_attribute :to_s, :email
  
  before_create do |eml|
    eml.activation_code = User.make_token 
  end
  
  after_create do |eml|
    eml.queue_notification
  end
  
  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end
  
  def name
    return self.user.name unless self.user.nil?
    uvcs = self.unvalidated_contributors
    #raise Exception.new('Expect user or unvalidated contribution!') if uvcs.size==0
    return uvcs[0].name unless uvcs.size==0
    return email.split('@')[0].gsub('.',' ').titleize
  end
  
  def orphaned? 
    user.nil? && unvalidated_contributors.empty?
  end
  
  # purges all the orphaned email addresses
  # returns the purged addresses
  def self.purge_orphaned!
    orphaned = self.all(:include=>[:user, :unvalidated_contributors]).collect do |email|
      if email.orphaned?
        email.destroy
        email.email
      else
        nil
      end
    end
    orphaned.compact
  end
  
  def active?
    self.activation_code.nil?
  end
  
  def activate
    self.activation_code = nil
    self.activated_at = Time.now
  end
  
  def queue_notification
    return if self.activation_code.nil?
    if active? 
      raise 'not expecting email_address to be active'
    elsif self.user
      self.notifications.create!(:action=>'added_email_address')
    end
  end
  
  def queue_forgot_password_notification
    self.notifications.create!(:action=>'forgot_password')
  end
  
  def queue_unvalidated_contributor_notification
    if self.user.nil?
      self.notifications.create!(:action=>'invitation')
    else
      self.notifications.create!(:action=>'added_to_project')      
    end
  end
  
end
