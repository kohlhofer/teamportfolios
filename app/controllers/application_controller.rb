# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

#turning off everything by default
before_filter :login_required
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  
end
