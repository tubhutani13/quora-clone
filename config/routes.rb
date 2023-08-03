Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"
  get "/signup", to: "users#new"
  resources :users do
    get "/followers", to: "users#followers"
    get "/following", to: "users#followees"
    member do
      get :confirm_email
      post "follow"
      post "unfollow"
    end
  end
  resources :passwords
  resources :sessions, only: [:new, :create, :destroy]

  resources :questions, param: :permalink do
    resources :answers do
      resources :comments
    end
    resources :comments
    collection do
      match "search" => "questions#search", via: [:get, :post], as: :search
    end
  end

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  get "/logout", to: "sessions#destroy"
end
