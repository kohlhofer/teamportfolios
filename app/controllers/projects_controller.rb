class ProjectsController < ApplicationController
  before_filter :login_required, :except => [ :index, :show ]

  def index
    @projects = Project.find(:all)
  end

  def show
    @project = Project.find_by_name(params[:id])
  end

  def new
    @project = Project.new()
  end
  
  def create
    @project = Project.new(params[:project])
    if @project.save
      Contribution.new(:user_id=>current_user.id, :project_id=>@project.id).save!
      redirect_to @project
    else
      render 'new'
    end
  end
end
