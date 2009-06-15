require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  
  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message
  
  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :name,     :maximum => 100
  
  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message
  
  alias_attribute :to_s, :name
  alias_attribute :to_param, :login
  
  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation, :strapline, :avatar, :bio
  
  has_many :contributions, :dependent=>:destroy
  has_many :projects, :through=>:contributions, :uniq=>true
  
  has_one :avatar
  
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
  
  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end
  
  def contributor_to? project
    projects.include? project
  end
  
  def collaborators
    if @_collaborators.nil?
      other_ids = []
      projects.each do |p|
        p.contributions.each do |c|
          other_ids << c.user_id if c.user_id != id
        end
      end
      @_collaborators = User.find(:all, :conditions => "id in (#{other_ids.join(',')})")
    end
    @_collaborators
  end
  def unvalidated_collaborator_names
    if @_unvalidated_collaborator_names.nil?
      @_unvalidated_collaborator_names = []
      projects.each do |p|
        p.unvalidated_contributors.each do |uvc|
          @_unvalidated_collaborator_names << uvc.name 
        end
      end
      @_unvalidated_collaborator_names .uniq!
    end
    @_unvalidated_collaborator_names
  end
  
  protected
  
end
