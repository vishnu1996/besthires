Rails.application.routes.draw do
  resources :resumes, only: [:index, :new, :create, :destroy]

  root to: 'sessions#new'

  devise_for :users

  get '/auth/:provider/callback', to: 'oauth#callback', as: 'oauth_callback'
  get '/auth/success', to: 'oauth#success', as: 'oauth_success'
  get '/auth/failure', to: 'oauth#failure', as: 'oauth_failure'
  match '/watson', to: 'oauth#watson', as: 'watson', via: [:get, :post]
  match '/watson_from_resume', to: 'oauth#watson_from_resume', as: 'watson_from_resume', via: [:get, :post]
  match '/logout', to: 'oauth#logout', as: 'session_logout', via: [:get, :delete]
  post '/webhook_testing', to: 'oauth#webhook_testing'


  resource :password, only: %w( new create edit update ), path_names: { edit: 'reset' }
  resources :users, only: %w( new create edit update )
  get 'users/:user_id/candidate/:candidate_id', to: 'users#candidate_view'
  resources :sessions, only: %w( new create destroy )

  
  get :user_sign_in, to: 'candidates#sign_in'

  get :success, to: 'sessions#success'
  get :logout, to: 'sessions#destroy'
  get :login, to: 'sessions#new'
  get :settings, to: 'sessions#settings'
  get :signup, to: 'users#new'


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
