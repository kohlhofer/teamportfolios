module LinkablesHelper
  def linkable 
    return @project unless @project.nil?
    return @user unless @user.nil?
    nil
  end
  
  def id_field 
    return :project_id unless @project.nil?
    return :user_id unless @user.nil?
    nil
  end
  
  def linkable_links_url
    return project_project_links_url(@project, :subdomain=>false) unless @project.nil?
    return user_user_links_url(@user, :subdomain=>false) unless @user.nil?
    nil
  end
end
