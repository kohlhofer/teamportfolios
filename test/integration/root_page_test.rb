require "#{File.dirname(__FILE__)}/../test_helper"

class RootPageTest < ActionController::IntegrationTest
  
  should "be able to view home page" do
    recount_stuff!
    get_ok '/'
    assert_select 'a[href=/users/alex]', :count=>0
    assert_select 'a[href=http://alex.teamportfolios.dev/]'
  end
  should 'be able to view exception page and get a 500' do
    get '/exception'
    assert_response 500
  end
  
  should "be able to contact us" do
    get_ok "/contact"
  end
  
  should "be able to get 404 fer unknown page" do
    get "/someunknownurl"
    assert_response_404
  end
  
  context "allowing forgery protection" do 
    setup do
      ApplicationController.send(:define_method, :protect_against_forgery?) {  true}
    end
    teardown do
      ApplicationController.send :remove_method, :protect_against_forgery? 
    end
    
    should "be able to get 404 when script kiddy posting data" do
      post "/horde/admin/cmdshell.php"
      assert_response_404
    end
    
  end
  
end
