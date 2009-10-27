require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  
  has_many :contributions, :dependent=>:destroy
  has_many :projects, :through=>:contributions, :uniq=>true
  has_many :links, :class_name => 'UserLink'
  has_one :avatar
  has_many :email_addresses, :conditions=>['activation_code is null'], :dependent=>:destroy
  has_many :unactivated_email_addresses, :class_name=>'EmailAddress', :conditions=>['activation_code is not null'], :dependent=>:destroy
  
  named_scope :featurable, :include => [:avatar, :projects], :conditions => [ "bio <> ? AND avatars.filename <> ? AND projects_count >= 3", '', '']
  named_scope :random_order, :order => "RAND()"
  
  
  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message
  
  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :name,     :maximum => 100
  
  alias_attribute :to_s, :name
  alias_attribute :to_param, :login
  
  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :name, :password, :password_confirmation, :strapline, :avatar, :bio
  
  def primary_email
    return email_addresses.first if email_addresses.size == 1
    email_addresses.detect{ |eml| eml.primary }
  end
  
  def unvalidated_contributions
    result = []
    email_addresses.each do |email_address| 
      result = result | email_address.unvalidated_contributors
    end
    result 
  end
  
  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_by_login(login.downcase) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end
  
  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end
  
  def forgot_password!
    self.update_attribute(:reset_password_code, self.class.make_token) if self.reset_password_code.nil?
    self.primary_email.queue_forgot_password_notification
  end
  
  def contributor_to? project
    projects.include? project
  end
  
  def sole_contributor_to? project
    project.contributors == [self]
  end
  
  def collaborators
    if @_collaborators.nil?
      other_ids = []
      projects.each do |p|
        p.contributions.each do |c|
          other_ids << c.user_id if c.user_id != id
        end
      end
      return [] if other_ids.empty?
      @_collaborators = User.find(:all, :conditions => "id in (#{other_ids.join(',')})")
    end
    @_collaborators
  end
  def unvalidated_collaborator_names
    if @_unvalidated_collaborator_names.nil?
      found_names = collaborators.collect {|c| c.name}
      @_unvalidated_collaborator_names = []
      projects.each do |p|
        p.unvalidated_contributors.each do |uvc|
          name = (!uvc.email_address.nil? && !uvc.email_address.user.nil?) ? uvc.email_address.user.name : uvc.name 
          @_unvalidated_collaborator_names << name unless found_names.include? name
          found_names << name
        end
      end
    end
    @_unvalidated_collaborator_names
  end
  
  protected
  
end
