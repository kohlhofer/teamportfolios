# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  skip_before_filter :login_required
  
  def new
  end
  
  def create
    logout_keeping_session!
    user = User.authenticate(params[:login], params[:password])
    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      redirect_back_or_default('/dashboard')
      flash[:notice] = "Logged in successfully"
    else
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end
  
  def destroy
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end
  
  def forgot_password
    @email = params[:email]
    
    return if request.get? || @email.blank?
    emladdr = EmailAddress.find_by_email(@email)
    if !emladdr
      flash[:error] = "Unable to find that email address in the system."
    else
      if emladdr.user.nil?
        emladdr.queue_notification 
        flash[:notice] = "An email to help you create your account will be sent to #{@email}."
      else
        emladdr.user.forgot_password! emladdr
        flash[:notice] = "An email to help you login will be sent to #{@email}."
      end      
      redirect_to login_url
    end
  end
  
  def reset_password
    @reset_password_code = params[:reset_password_code]
    return if @reset_password_code.blank?
    @user = User.find_by_reset_password_code(@reset_password_code)
    return if !@user
    return if !params[:user].is_a? Hash
    if !@user.update_attributes(:password=>params[:user][:password], :password_confirmation=>params[:user][:password_confirmation], :reset_password_code=>nil)
      redirect_to :action=>'new'
    else
      flash[:error] = 'Some problem resetting your password.'
    end
  end
  
  protected
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "Couldn't log you in as '#{params[:login]}'"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
