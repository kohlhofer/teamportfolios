class EmailAddress < ActiveRecord::Base
  belongs_to :user
  has_many :unvalidated_contributors, :dependent => :nullify
  has_many :notifications, :dependent => :destroy
  
  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message
  
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
    raise Exception.new('Expect user or unvalidated contribution!') if uvcs.size==0
    uvcs[0].name
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
      self.notifications.create!(:action=>'forgot_password')
    elsif self.user
      self.notifications.create!(:action=>'added_email_address')
    end
  end
  
  def queue_unvalidated_contributor_notification
    if self.user.nil?
      self.notifications.create!(:action=>'invitation')
    else
      self.notifications.create!(:action=>'added_to_project')      
    end
  end
end
