require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead.
  # Then, you can remove it from this and the functional test.
  include AuthenticatedTestHelper
  fixtures :users
  
  def test_should_create_user
    assert_difference 'User.count' do
      user = create_user
      assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
    end
  end
  
  def test_should_require_login
    assert_no_difference 'User.count' do
      u = create_user(:login => nil)
      assert u.errors.on(:login)
    end
  end
  
  def test_should_require_password
    assert_no_difference 'User.count' do
      u = create_user(:password => nil)
      assert u.errors.on(:password)
    end
  end
  
  def test_should_require_password_confirmation
    assert_no_difference 'User.count' do
      u = create_user(:password_confirmation => nil)
      assert u.errors.on(:password_confirmation)
    end
  end
  
  def test_should_require_email
    assert_no_difference 'User.count' do
      u = create_user(:email => nil)
      assert u.errors.on(:email)
    end
  end
  
  def test_should_reset_password
    users(:quentin).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal users(:quentin), User.authenticate('quentin', 'new password')
  end
  
  def test_should_not_rehash_password
    users(:quentin).update_attributes(:login => 'quentin2')
    assert_equal users(:quentin), User.authenticate('quentin2', 'monkey')
  end
  
  def test_should_authenticate_user
    assert_equal users(:quentin), User.authenticate('quentin', 'monkey')
  end
  
  def test_should_set_remember_token
    users(:quentin).remember_me
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
  end
  
  def test_should_unset_remember_token
    users(:quentin).remember_me
    assert_not_nil users(:quentin).remember_token
    users(:quentin).forget_me
    assert_nil users(:quentin).remember_token
  end
  
  def test_should_remember_me_for_one_week
    before = 1.week.from_now.utc
    users(:quentin).remember_me_for 1.week
    after = 1.week.from_now.utc
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
    assert users(:quentin).remember_token_expires_at.between?(before, after)
  end
  
  def test_should_remember_me_until_one_week
    time = 1.week.from_now.utc
    users(:quentin).remember_me_until time
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
    assert_equal users(:quentin).remember_token_expires_at, time
  end
  
  def test_should_remember_me_default_two_weeks
    before = 2.weeks.from_now.utc
    users(:quentin).remember_me
    after = 2.weeks.from_now.utc
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
    assert users(:quentin).remember_token_expires_at.between?(before, after)
  end
  
  should "know what has contributed to" do
    alex = users(:alex)
    assert alex.contributor_to?(projects(:weewar)) 
    assert !alex.contributor_to?(projects(:cleverplugs)) 
  end
  should "know what has sole contributed to" do
    alex = users(:alex)
    tim = users(:tim)
    assert  !alex.sole_contributor_to?(projects(:weewar))
    assert  tim.sole_contributor_to?(projects(:treesforcities))
  end
  
  should "know fellow collaborators" do
    alex = users(:alex)
    collabs = alex.collaborators 
    assert_equal 3, collabs.length
    assert collabs.include?(users(:bert))
    assert collabs.include?(users(:duff))
    assert collabs.include?(users(:tim))
  end
  
  should "know fellow unvalidated_collaborator_names" do
    tim = users(:tim)
    collabs = tim.unvalidated_collaborator_names
    assert_equal 1, collabs.length
    assert collabs.include?("Alexxx Khlhofer")
  end
  
  should "know fellow unvalidated_collaborator_names to not include identical to validated" do
    alex = users(:alex)
    collabs = alex.unvalidated_collaborator_names
    assert_equal 0, collabs.length
  end

  should "know projects where contributions match unvalidated contribution" do
    alex = users(:alex)
    uvcs = alex.unvalidated_contributions
    assert_equal 2, uvcs.size
    uvcs.each {|uvc| puts " * #{uvc.email}, #{uvc.project}"}
  end
  
  protected
  def create_user(options = {})
    record = User.new({ :login => 'quire', :email => 'quire@example.com', :password => 'quire69', :password_confirmation => 'quire69' }.merge(options))
    record.save
    record
  end
end
