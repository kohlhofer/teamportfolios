class ProjectsController < ApplicationController
  before_filter :find_project, :except=> [:index, :new, :create]
  before_filter :login_required, :except => [ :index, :show ]
  before_filter :require_contributor, :except => [:index, :show, :new, :create]
  before_filter :check_for_hide_admin, :only=>:show
  
  def index
    @projects = Project.find(:all)
  end
  
  def show
    @unvalidated_contributor = UnvalidatedContributor.new(:project_id => @project.id)
    @show_admin = logged_in? && current_user.contributor_to?(@project) unless @show_admin == false
  end
  
  def new
    @project = Project.new()
    @project.links.build(:label=>'homepage', :url=>'http://')
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
  
  def edit
  end
  
  def update
    if @project.update_attributes(params[:project])
      flash[:notice] = 'Project was successfully updated.'
      redirect_to(@project) 
    else
      render :action => "edit" 
    end        
  end
  
  def leave
    @project.contributors.delete(current_user)
    redirect_to @project    
  end
  
  def destroy
    @project.destroy
    redirect_to current_user    
  end
  
  protected
  def find_project
    @project = Project.find_by_name(params[:id])
    if @project.nil?
      render_404 'unknown_project'
      return false
    end
  end
  
end
