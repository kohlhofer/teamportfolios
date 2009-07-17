class ProjectLinksController < ApplicationController
  include ProjectDescendantController

  before_filter :find_project
  before_filter :require_contributor


#  # GET /project_links
#  # GET /project_links.xml
#  def index
#    @project_links = ProjectLink.all
#
#    respond_to do |format|
#      format.html # index.html.erb
#      format.xml  { render :xml => @project_links }
#    end
#  end
#
#  # GET /project_links/1
#  # GET /project_links/1.xml
#  def show
#    @project_link = ProjectLink.find(params[:id])
#
#    respond_to do |format|
#      format.html # show.html.erb
#      format.xml  { render :xml => @project_link }
#    end
#  end

  # GET /project_links/1/edit
  def edit
    @project_link = ProjectLink.find(params[:id])
  end

  # POST /project_links
  # POST /project_links.xml
  def create
    @project_link = ProjectLink.new(params[:project_link])

    respond_to do |format|
      if @project_link.save
        flash[:notice] = 'ProjectLink was successfully created.'
        format.html { redirect_to(@project) }
        format.xml  { render :xml => @project_link, :status => :created, :location => @project_link }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project_link.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /project_links/1
  # PUT /project_links/1.xml
  def update
    @project_link = ProjectLink.find(params[:id])

    respond_to do |format|
      if @project_link.update_attributes(params[:project_link])
        flash[:notice] = 'ProjectLink was successfully updated.'
        format.html { redirect_to(@project) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project_link.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /project_links/1
  # DELETE /project_links/1.xml
  def destroy
    @project_link = ProjectLink.find(params[:id])
    @project_link.destroy

    respond_to do |format|
      format.html { redirect_to(@project) }
      format.xml  { head :ok }
    end
  end
end
