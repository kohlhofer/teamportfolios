require 'test_helper'

class RoutingTest < ActionController::IntegrationTest
#  include ActionController::Assertions::RoutingAssertions
#  def clean_backtrace(&block)
#    yield
#  rescue ActiveSupport::TestCase::Assertion => error
#    framework_path = Regexp.new(File.expand_path(
#                                     "#{File.dirname(__FILE__)}/assertions"))
#    error.backtrace.reject! { |line| File.expand_path(line) =~ framework_path }
#    raise
#  end
  
  
  def test_project_links
    opts = {:controller=>'project_links', :project_id=>'weewar', :id=>project_links(:weewar_homepage).id.to_s, :action=>'show'}
      assert_routing(show_weewar_homepage, opts)
      assert_generates(show_weewar_homepage, opts)
      assert_recognizes(opts, show_weewar_homepage)
  end
  def test_project_project_links_path
      assert_equal(show_weewar_homepage, project_project_link_path(projects(:weewar), project_links(:weewar_homepage)))
  end
  
  def show_weewar_homepage
    "/projects/weewar/project_links/#{project_links(:weewar_homepage).id}"
  end
  
end