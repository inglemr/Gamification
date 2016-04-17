Rails.application.routes.draw do

    namespace :kiosk do
      get "log_in" => "sessions#new", :as => "log_in"
      get "log_out" => "sessions#destroy", :as => "log_out"
      get 'index' => "kiosk_pages#index"
      resources :kiosks
      resources :sessions
      #root 'kiosk_pages#index', as: :kiosk_root
      controller :kiosk_pages do
        get 'list' => "kiosk_pages#list_events"
        get 'main' => "kiosk_pages#main"
        post 'main' => "kiosk_pages#main"
        get ':event_id/end_event' => "kiosk_pages#end_event", :as => 'end_event'
        get ':event_id/manage' => "kiosk_pages#manage", :as => 'manage'
        get ':event_id/swipe' => "kiosk_pages#swipe", :as => 'swipe'
        post ':event_id/new_swipe' => "kiosk_pages#new_swipe" , :as => 'new_swipe'
        get "kiosk_pages/:id/generate_qrcodes" => "kiosk_pages#generate_qrcodes", format: :svg
      end
    end

  get 'events/:id/show' => 'events#show', :as => "show_events"
  get 'dashboard/index'
  get 'cal_events' => 'dashboard#cal_events'
  devise_for :users, :controllers => {:confirmations => 'confirmations'}

  devise_scope :user do
       match '/users/confirmation' => 'confirmations#update', :via => :patch, :as => :update_user_confirmation
    authenticated :user do
      root 'dashboard#index', as: :authenticated_root
      controller :settings do
          get :settings
          post :updatesettings
      end
      namespace :admin do
        resources :organization do
        end
        resources :events do
        end
        resources :tag do
        end
        resources :rooms do
        end
        resources :user do
        end
        resources :roles do
        end
        resources :permissions do
        end
        resources :log do
        end
        resources :location do
          get 'events' => 'location#events'
        end
      end
      resource :events do
         match ':id/csv' => 'events#csv', :via => [:get, :post], :as => "csv"
         match ':id/manage' => 'events#manage', :via => [:get, :post], :as => "manage"
         get '/my_points' => 'events#my_points'
         get '/all_events' => 'events#all_events'
         collection do
          get :index
         end
      end

      resource :organizations do
          get 'show/:id' => 'organizations#show', :as => "show"
          post 'member_page/:id/new_role' => 'organizations#new_role', :as => "new_role"
          patch 'member_page/:id/member_role/:member_id' => 'organizations#member_role', :as => "member_role"
          get 'member_page/:id' => 'organizations#member_page', :as => "member_page"
         collection do
          get :index
         end
      end

      resource :location do
        get '/:id' => 'location#show'
        collection do
          get :index
        end
      end
      match ':controller(/:action(/:id))', :via => [:get, :post]
    end
    root 'devise/sessions#new'
    namespace :api, :defaults => {:format => :json} do
      namespace :v1 do
        resources :user do
          collection do
            get :add_event
            post :add_event
          end
        end
      end
    end
  end
  # You c
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
