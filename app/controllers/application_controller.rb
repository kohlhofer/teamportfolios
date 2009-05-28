# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  helper :all # include all helpers, all the time
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
end
