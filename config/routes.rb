Rails.application.routes.draw do
  devise_for :kiosks

  devise_scope :kiosk do
    authenticated :kiosk do
      root 'kiosk_pages#index', as: :kiosk_root
      controller :kiosk_pages do
        get 'list' => "kiosk_pages#list_events"
        get 'main' => "kiosk_pages#main"
        post 'main' => "kiosk_pages#main"
        get 'kiosk/:event_id/manage' => "kiosk_pages#manage"
        get 'kiosk/:event_id/swipe' => "kiosk_pages#swipe"
        post 'kiosk/:event_id/new_swipe' => "kiosk_pages#new_swipe"
      end
    end
  end


  get 'dashboard/index'
  get 'cal_events' => 'dashboard#cal_events'
  devise_for :users
  devise_scope :user do
    authenticated :user do
      root 'dashboard#index', as: :authenticated_root
      controller :settings do
          get :settings
          post :updatesettings
      end
      namespace :admin do
        resources :kiosks do
          post 'admin/kiosks' => 'kiosks#create'
        end
        resources :events do
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
         get 'events/:id' => 'events#show'
         get '/my_points' => 'events#my_points'
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
