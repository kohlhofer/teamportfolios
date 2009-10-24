class SubdomainRootController < ApplicationController
  before_filter :check_for_hide_admin

  def index
    user = SubdomainFu.subdomain_from(request.host)
    @user = User.find_by_login(user)
    return render_404('users/unknown_user') if @user.nil?
    #return redirect_to(url_for(:controller=>'users', :action=>:show, :id=>user, :subdomain=>false)) if @user.nil?
    @show_admin = logged_in? && current_user == @user unless !@show_admin.nil?
    render :template => 'users/show'
  end

end
