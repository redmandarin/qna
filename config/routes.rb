require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  root to: "questions#index"
  devise_for :users, path: "u", controllers: { omniauth_callbacks: 'omniauth_callbacks', registrations: 'registrations' }

  delete 'attachments/:id', to: 'attachments#destroy'
  
  get 'tags/:tag', to: 'questions#index', as: 'tag'
  post 'subscriptions', to: 'subscriptions#create'

  resources :search, only: :index

  concern :commentable do
    resources :comments
  end

  concern :voteable do
    resources :votes, only: [:create, :update]
  end
  
  resources :questions, concerns: [:commentable, :voteable], shallow: true do
    resources :answers, concerns: [:commentable, :voteable] do
      patch 'mark_best', on: :member
    end

    collection do
      get 'index', to: 'question#index', scope: 'best_first'
    end
  end

  resources :users, only: [:index, :show]
  
  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get 'me', on: :collection
      end
      resources :questions, shallow: true do
        resources :answers
      end
    end
  end
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
