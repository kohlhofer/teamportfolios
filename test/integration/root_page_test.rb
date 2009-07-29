require "#{File.dirname(__FILE__)}/../test_helper"

class RootPageTest < ActionController::IntegrationTest
  should "be able to view home page" do
    get_ok '/'
  end
  
  should 'be able to view exception page and get a 500' do
    get '/exception'
    assert_response 500
  end
  
  should "be able to contact us" do
    get_ok "/contact"
  end
end
