class ProjectLinksController < LinksController
  include ProjectDescendantController
  
  protected 
  def find_linkable
    find_project
    @linkable = @project
    require_contributor
  end
  def find_link
    @link = @project_link = ProjectLink.find(params[:id])
  end
  def link_params
    params[:project_link]
  end
  def create_link
    @project_link = ProjectLink.new(link_params)
  end
  
end
