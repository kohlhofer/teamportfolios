class ProjectsController < ApplicationController
  def index
    @projects = Project.find(:all)
  end

  def show
    @project = Project.find_by_name(params[:id])
  end

end
