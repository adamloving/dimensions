RailsBootstrap::Application.routes.draw do

  devise_for :admin_users,{
    :path => :admin,
    :path_names => { :sign_in => 'login', :sign_out => "logout" }
  }



  devise_for :users
  namespace :admin do
    resources :pages, :only => :index
  end

  namespace :admin do
    resources :news_feeds do
      get :process_entries, :on => :member
      post :load_entries, :on => :member
      get :search, :on => :collection
      resources :feed_entries do
        put :toggle_visible, :on => :member
        post :fetch_content, :on => :member
        post :process_entry, :on => :member
        get :review_locations, :on => :collection
        resources :entities do
          put :set_primary_location,:on => :member,:controller=>:feed_entries
        end
      end
    end

    resources :feed_entries, :only => :index do
      get :search, :on => :collection
    end
    root :to => "news_feeds#index"
  end


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  match 'signup' => "users#create"
  match 'home' => "home#index"
  match 'product' => "product#show"
  match 'mobile' => "home#mobile"
  match 'search' => "search#index"
  match 'article/:ids' => "search#article"
  
  match 'api/paypal', :to => 'api/paypal#create', :via => %w(post)
  
  root :to => "home#launch"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
