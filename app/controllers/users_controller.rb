class UsersController < ApplicationController
  before_filter :check_for_hide_admin, :only=>:show
  before_filter :check_params_for_activation_code, :only => [:new, :create]

  def index 
    @users = User.all
  end
  
  def new
    if !@email_address.nil?
      @user = User.new(:name=>@email_address.name, :login=>@email_address.name.strip.downcase.gsub(/[^a-zA-Z0-9]+/,'_'))
    end
  end
  
  
  def create
    check_params_for_activation_code
    if !@has_activation
      render 'new' 
      return
    end
    logout_keeping_session!
    @user = User.new(params[:user])
    @email_address.user = @user
    @email_address.activate
    success = @user && @user.save && @email_address.save 
    if success && @user.errors.empty?
      # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_user = @user # !! now logged in
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!"
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end
  
  def show
    @user = User.find_by_login(params[:id])
    @show_admin = logged_in? && current_user == @user unless !@show_admin.nil?
  end
  
  protected
  def check_params_for_activation_code
    @email = params[:email]
    @activation_code = params[:activation_code]
    @email_address = EmailAddress.find_by_email(@email)
    return if @email_address.nil?
    @has_activation = ( @activation_code == @email_address.activation_code)
  end
  
end
