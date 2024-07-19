Rails.application.routes.draw do
  get 'relationships/create'
  get 'relationships/destroy'
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "home", to: "static_pages#home", as: :home
    get "help", to: "static_pages#help", as: :help
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    get "/login" , to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout" , to: "sessions#destroy"
    resources :users
    resources :account_activations, only: :edit
    resources :password_resets, except: %i(index show destroy)
    resources :microposts, only: %i(create destroy)
    resources :relationships, only: %i(create destroy)
    resources :users do
      member do
        get :following, :followers
      end
    end
  end
end
