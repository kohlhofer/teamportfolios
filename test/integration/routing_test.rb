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
  
  should "go to  subdomain root controller when has subdomain" do
    url = "http://tim.teamportfolios.dev/"
    opts = {:controller=>'subdomain_root', :action=>'index'}    
    assert_recognizes(opts, url)
    opts[:subdomain] ='tim'
    assert_equal(url, url_for(opts))
  end
  
  should "go to  main root controller when has no subdomain" do
    url = "http://teamportfolios.dev/"
    opts = {:controller=>'root', :action=>'index'}    
    assert_recognizes(opts, url)
    assert_equal(url, url_for(opts))
  end
  
  should "parseurlorpath should work" do
    assert_parses("teamportfolios.dev", '', "http://teamportfolios.dev")
    assert_parses("teamportfolios.dev", '/', "http://teamportfolios.dev/")
    assert_parses("teamportfolios.dev", '/blah', "http://teamportfolios.dev/blah")
    assert_parses(nil, '/blah', "/blah")
  end
  
  def assert_parses(expected_host, expected_path, url)
    host, path = parseurlorpath(url)
    assert_equal(expected_host, host)
    assert_equal(expected_path, path)
  end
end

module ActionController
  module Assertions
    module RoutingAssertions
      
      private
      def recognized_request_for(path, request_method = nil, host=nil)
        host, path = parseurlorpath(path)
        path = "/#{path}" unless path.first == '/'
        
        # Assume given controller
        request = ActionController::TestRequest.new
        request.env["REQUEST_METHOD"] = request_method.to_s.upcase if request_method
        request.path   = path
        request.host = host unless host.nil?
        
        ActionController::Routing::Routes.recognize(request)
        request
      end
      
      public 
      def parseurlorpath(url)
        mtch = %r{http://([^/]+)(/.*)?}.match(url)
        if mtch
          host = mtch[1]
          path = mtch[2] || ''
        else
          host = nil
          path = url
        end
        return host, path
      end
    end
    
  end
end