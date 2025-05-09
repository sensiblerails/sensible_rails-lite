Rails.application.routes.draw do
  # Home routes
  root "home#index"
  get "home/index"

  # Authentication routes
  get "signup", to: "users#new"
  post "signup", to: "users#create"
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  # Password reset routes
  resources :password_resets, only: [ :new, :create, :edit, :update ]

  # User impersonation routes
  post "impersonate/:id", to: "users#impersonate", as: :impersonate
  post "stop_impersonating", to: "users#stop_impersonating", as: :stop_impersonating

  # Resources
  resources :users, only: [ :index, :show, :new, :create, :edit, :update ]
  resources :posts

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
