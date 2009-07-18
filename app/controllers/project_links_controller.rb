class ProjectLinksController < LinksController
  include ProjectDescendantController
  before_filter :require_contributor
  
  protected 
  def find_linkable
    find_project
    @linkable = @project
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
