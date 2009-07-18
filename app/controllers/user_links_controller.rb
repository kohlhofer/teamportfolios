class UserLinksController < LinksController
  
  protected 
  def find_linkable
    @user = User.find_by_login(params[:user_id])
    return access_denied unless authorized? 
    if current_user != @user
      return access_forbidden
    end
    @linkable = @user
  end
  
  def find_link
    @link = @user_link = UserLink.find(params[:id])
  end
  
  def link_params
    params[:user_link]
  end
  def create_link
    @user_link = UserLink.new(link_params)
  end
  
  
end
