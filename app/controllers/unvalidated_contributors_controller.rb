class UnvalidatedContributorsController < ApplicationController
  # GET /unvalidated_contributors
  # GET /unvalidated_contributors.xml
  def index
    @unvalidated_contributors = UnvalidatedContributor.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @unvalidated_contributors }
    end
  end
  
  # GET /unvalidated_contributors/1
  # GET /unvalidated_contributors/1.xml
  def show
    @unvalidated_contributor = UnvalidatedContributor.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @unvalidated_contributor }
    end
  end
  
  # GET /unvalidated_contributors/new
  # GET /unvalidated_contributors/new.xml
  def new
    @unvalidated_contributor = UnvalidatedContributor.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @unvalidated_contributor }
    end
  end
  
  # GET /unvalidated_contributors/1/edit
  def edit
    @unvalidated_contributor = UnvalidatedContributor.find(params[:id])
  end
  
  # POST /unvalidated_contributors
  # POST /unvalidated_contributors.xml
  def create
    @unvalidated_contributor = UnvalidatedContributor.new(params[:unvalidated_contributor])
    
    respond_to do |format|
      if @unvalidated_contributor.save
        if (@unvalidated_contributor.email.nil?)
          flash[:notice] = "Added #@unvalidated_contributor to list."
        else
          flash[:notice] = "Added #@unvalidated_contributor to list. Waiting for response for profile linking."
        end
        format.html { redirect_to(@unvalidated_contributor.project) }
        format.xml  { render :xml => @unvalidated_contributor, :status => :created, :location => @unvalidated_contributor }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @unvalidated_contributor.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /unvalidated_contributors/1
  # PUT /unvalidated_contributors/1.xml
  def update
    @unvalidated_contributor = UnvalidatedContributor.find(params[:id])
    
    respond_to do |format|
      if @unvalidated_contributor.update_attributes(params[:unvalidated_contributor])
        flash[:notice] = 'UnvalidatedContributor was successfully updated.'
        format.html { redirect_to(@unvalidated_contributor) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @unvalidated_contributor.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /unvalidated_contributors/1
  # DELETE /unvalidated_contributors/1.xml
  def destroy
    @unvalidated_contributor = UnvalidatedContributor.find(params[:id])
    @unvalidated_contributor.destroy
    
    respond_to do |format|
      format.html { redirect_to(unvalidated_contributors_url) }
      format.xml  { head :ok }
    end
  end
end
