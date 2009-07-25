class EmailAddress < ActiveRecord::Base
  belongs_to :user
  has_many :unvalidated_contributors, :dependent => :nullify
  
  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message
  
  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end
  
  def active?
    self.activation_code.nil?
  end
end
