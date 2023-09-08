Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resource :users , :companies
  resource :jobs , :skills
  # resources :companies , only: :index
  post "/auth/login", to: "authentication#login"
end
