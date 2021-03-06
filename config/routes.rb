ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'subdomain_root', :conditions => {:subdomain => true}
  map.connect "*path", :controller => "root", :action => "render_404", :conditions => {:subdomain => true}
  
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.forgot_password '/login/forgot_password', :controller => 'sessions', :action => 'forgot_password'
  map.reset_password 'reset/:reset_password_code', :controller => "sessions", :action => 'reset_password', :reset_password_code=>nil
  map.join '/join', :controller => 'users', :action => 'new'

  map.exception '/exception', :controller => 'root', :action => 'exception'
  map.contact '/contact', :controller => 'root', :action => 'contact'
  map.resources :users do |user|
    user.resources :user_links
  end
  map.resources :projects, :member=>{:leave => :put } do |project| 
#    project.resources :contributors
    project.resources :unvalidated_contributors, :member => {:validate_self => :put, :refuse_self => :put}
    project.resources :images
    project.resources :project_links
  end
  map.resource :session
  map.dashboard '/dashboard', :controller => 'settings', :action => 'show'
  map.resource :settings, :collection => { :account => :get, :save_new_avatar => :put, :edit_avatar => :get, :profile => :get}

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.root :controller => 'root', :conditions => {:subdomain => false}
  
  map.connect "*path", :controller => "root", :action => "render_404"
end
