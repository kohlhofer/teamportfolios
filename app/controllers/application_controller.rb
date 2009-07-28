# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include ExceptionNotifiable

  helper :all # include all helpers, all the time
  helper :layout
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  protected
  def access_forbidden
    render :text=>"Forbidden", :status=>:forbidden
  end
  
  def require_contributor
    return access_denied unless authorized? 
    if ! current_user.contributor_to? @project
      return access_forbidden
    end
  end
  
  def check_for_hide_admin
      @hiding_admin = true if params[:hide_admin]=='true'
      @show_admin = false if @hiding_admin
  end
  
end


module ProjectDescendantController
  
  protected
  def find_project
    @project = Project.find_by_name!(params[:project_id])
  end
  
end