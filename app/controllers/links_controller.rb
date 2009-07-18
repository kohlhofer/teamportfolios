class LinksController < ApplicationController
  before_filter :find_linkable
  before_filter :find_link, :only => [:edit, :update, :destroy]
  
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
  end
  
  # POST /project_links
  # POST /project_links.xml
  def create
    @link = create_link
    respond_to do |format|
      if @link.save
        flash[:notice] = "Link to '#{@link.url}' was successfully created."
        format.html { redirect_to(@linkable) }
        format.xml  { render :xml => @link, :status => :created, :location => @link }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @link.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /project_links/1
  # PUT /project_links/1.xml
  def update
    respond_to do |format|
      if @link.update_attributes(link_params)
        flash[:notice] = "Link to '#{@link.url}' was successfully updated."
        format.html { redirect_to(@linkable) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @link.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /project_links/1
  # DELETE /project_links/1.xml
  def destroy
    @link.destroy
    
    respond_to do |format|
      format.html { redirect_to(@linkable) }
      format.xml  { head :ok }
    end
  end
  
  
  #abstract stuff to define:
  protected 
  def find_linkable
    raise 'define in your own class'
  end
  def find_link
    raise 'define in your own class'
  end
  def link_params
    raise 'define in your own class'
  end
  def create_link
    raise 'define in your own class'
  end
  
end