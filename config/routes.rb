Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :users do 
    get 'user_company' , on: :collection
  end
  
  resources :companies , :skills, :job_applications

  resources :jobs do 
  	get 'current_company_jobs' , on: :collection
  end
  
  post "/auth/login", to: "authentication#login"
  post 'jobs/:job_id/apply', to: 'job_applications#apply'
  get "/suggested_jobs", to: "users#suggested_jobs"
  get "/top_jobs", to: "jobs#top_jobs"
  get "/all_applied_jobs", to: "users#all_applied_jobs"
  get "/user_skills", to: "skills#user_skills"
  get "/specific_job/:id", to: "users#specific_job"
end
