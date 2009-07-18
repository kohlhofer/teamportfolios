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
  
end
