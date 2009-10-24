ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")

$: << File.expand_path(File.dirname(__FILE__) + "/integration/dsl")
require 'basics_dsl'
require 'teamportfolios_dsl'
require 'test_help'
require File.dirname(__FILE__) + '/teamportfolio_test_helper'
require "webrat"

Webrat.configure do |config|
  config.mode = :rails
end

class ActiveSupport::TestCase
  self.use_transactional_fixtures = true
  
  self.use_instantiated_fixtures  = false
  
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all
  
  # Add more helper methods to be used by all tests here...
  include AuthenticatedTestHelper
  include TeamportfolioTestHelper
end

class ActionController::IntegrationTest
  
  def new_session(&block) 
    open_session do | session | 
      session.extend(BasicsDsl)
      session.extend(TeamportfoliosDsl)
      session.host!("teamportfolios.dev")
      session.instance_eval(&block) if block
      session
    end 
  end 
  
  def new_session_as(user_symbol, &block)
    session = new_session
    session.login(user_symbol)
    session.instance_eval(&block) if block
    session
  end 
  
  def logger
    Rails.logger
  end
  
  @@preview_mail = false
  
  def view_mail email_or_name_or_options = nil
    email = name = nil
    if email_or_name_or_options.nil?
      #nothing
    elsif email_or_name_or_options.is_a? Hash
      email = email_or_name_or_options[:email]
      name = email_or_name_or_options[:name]
    elsif email_or_name_or_options.is_a?(String) || email_or_name_or_options.is_a?(Symbol)
      name = email_or_name_or_options
    else
      email =email_or_name_or_options
    end
    name = 'email' if name.nil?
    email = @emails.first if email.nil?
    filename = File.dirname(__FILE__) + "/../public/.integration_test_#{name}.text"
    flunk("There was no response to view") unless email
    File.open(filename, "w+") { | file | file.write(email) }
    `open #{filename}`
  end
  
  def preview_mail email_or_name_or_options
    if @@preview_mail
      view_mail  email_or_name_or_options
    end
  end
  
  def assert_response_404
    assert_response 404
    assert_select "a[href=http://teamportfolios.dev/]"
  end
  
  
end


module ActionController
  module Integration
    module Runner
      def reset!
        @integration_session = new_session
      end
    end
  end
end


module ProjectTestHelper
  def add_contributor name, email=nil
    assert_select 'form#add-contributor', :count=>1
    fill_in 'unvalidated_contributor[name]', :with => name
    fill_in 'email', :with => email unless email.nil?
    submit_form "add-contributor" 
    follow_redirect!
    assert_response_ok
  end
end