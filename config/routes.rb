Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :users do 
    get 'user_company' , on: :collection
  end
  
  resources :companies , :jobs , :skills, :job_applications
  
  post "/auth/login", to: "authentication#login"
  post 'jobs/:job_id/apply', to: 'job_applications#apply'
  get "/suggested_jobs", to: "users#suggested_jobs"
  get "/top_jobs", to: "jobs#top_jobs"
  get "/all_applied_jobs", to: "users#all_applied_jobs"
end
