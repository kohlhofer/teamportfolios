class RootController < ApplicationController
  def index
    @projects = Project.find(:all)
  end
end
