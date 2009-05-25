class RootController < ApplicationController
#turning off everything by default

  def index
    @projects = Project.find(:all)
  end
end
