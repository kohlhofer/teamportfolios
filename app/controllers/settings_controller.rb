class SettingsController < ApplicationController
  before_filter :login_required
  before_filter :set_user
  
  def show
    render :edit
  end
  
  
  def update    
    @user.attributes = params[:user]
    
    return render(:action => :edit) unless (@user.valid? && @user.save)
    
    flash[:notice] = "Successfully updated settings"
    redirect_to @user
  end
  
  
  def save_new_avatar
    avatar = Avatar.new(params[:user])
    avatar.user_id = @user.id
    unless avatar.valid? && avatar.save
      return render(:edit_avatar)
    end
    
    flash[:notice] = 'Saved avatar.'
    redirect_to @user     
  end

  
  private
  def set_user
    @user = current_user
  end
  
end
