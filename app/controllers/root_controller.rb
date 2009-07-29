class RootController < ApplicationController
#turning off everything by default

  def index
    @projects = Project.find(:all)
  end
  
  def exception
    raise Exception.new('This is a deliberate exception raised to test exception notification (by email on the live server)')
  end
  
  def contact
    
  end
end
