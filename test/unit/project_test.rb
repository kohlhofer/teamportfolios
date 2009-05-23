require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  context "New Project" do
    should "have name following title" do
      p = Project.new(:title=>'some_title')
      p.save!
      assert_equal 'some_title', p.name
    end
    
    should "convert spaces to underscores and ignore punct" do
      p = Project.new(:title=>'Some Title!')
      p.save!
      assert_equal 'some_title', p.name
    end
  
    should "ignore leading and trailing spaces in title" do
      p = Project.new(:title=>' Some Title ')
      p.save!
      assert_equal 'some_title', p.name
    end
  
    should "ignore eading and trailing underscores in title" do
      p = Project.new(:title=>'_Some Title_')
      p.save!
      assert_equal 'some_title', p.name
    end
    
  end

  context "Existing Project" do
    should "have existing contributors" do
      p = projects(:weewar)
      assert_equal 1, p.contributors.count
      
      p = projects(:tcr)
      assert_equal 3, p.contributors.count
    end
  end
end
