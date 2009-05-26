module ProjectsHelper
  def main_project_image_for(project, size=:small)
    if project.image
      project_image_for(project.image, size, project.to_s)
    else
      image_tag("project_preview_#{size}.png",       :class => "project_image_#{size}", :alt=>project)
    end  
  end
  def project_image_for(image, size=:small, alt=nil) 
    image = image
    image_tag(
      image.public_filename(size),
      :class => "project_image_#{size}", 
      :alt=> (!alt.nil? ? alt : (size==:small ? nil : (image.nil? ? 'image': image.caption)))
    )
  end
  
  def link_using_main_project_image(project, size=:small, html_options = {}) 
    link_to(main_project_image_for(project, size), project, html_options)
  end
  
end
