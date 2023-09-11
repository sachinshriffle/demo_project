Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :users
  resources :companies , :jobs , :skills
  resources :job_applications
  post "/auth/login", to: "authentication#login"
  post 'jobs/:job_id/apply', to: 'job_applications#apply'
  put 'job_applications/:id/:status', to: 'job_applications#update_status'
  get "/suggested_jobs", to: "jobs#suggested_jobs"
end
