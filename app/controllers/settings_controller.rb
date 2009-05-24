class SettingsController < ApplicationController
  
  def show
    @user = current_user
    render :edit
  end
  
  
  def update
    @user = current_user
    
    @user.attributes = params[:user]
    
    return render(:action => :edit) unless (@user.valid? && @user.save)
    
    flash[:notice] = "Successfully updated settings"
    redirect_to @user
  end
  
end
