class RootController < ApplicationController
#turning off everything by default
before_filter :login_required
  def index
    @projects = Project.find(:all)
  end
end
