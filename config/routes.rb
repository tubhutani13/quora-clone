Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"
  get "/signup", to: "users#new"
  resources :users do
    get "/followers", to: "users#followers"
    get "/following", to: "users#followees"
    get "credits"
    member do
      get :confirm_email
      post "follow"
      post "unfollow"
    end
  end

  resources :credit_packs, only: [:index]
  resource :transactions, only: [:create]
  resources :orders, only: [:create], param: :code do
    get "checkout", on: :member
    get "success", on: :member
    get "failure", on: :member
  end
  resources :passwords
  resources :sessions, only: [:new, :create, :destroy]
  resources :reports
  resources :questions, param: :permalink do
    resources :answers do
      resources :comments
    end
    resources :comments
    collection do
      match "search" => "questions#search", via: [:get, :post], as: :search
    end
  end

  namespace :api do
    get "feed", to: "users#feed", format: true, constraints: { format: :json }
    resources :topics, only: [:index, :show], param: :topic do
      get "/:x", to: "topics#show", on: :member
    end
  end

  scope controller: :votes, path: 'vote' do
    post 'upvote'
    post 'downvote'
  end
  
  resource :admin, only: [:show], module: :admin do
    get "users"
    get "questions"
    get "answers"
    get "comments"
    patch 'disable_user'
    patch 'disable_entity'
  end

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  get "/logout", to: "sessions#destroy"
end
