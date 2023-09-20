Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :users do
    get 'user_company', on: :collection
    get 'forgot_password', on: :collection
    get 'reset_password', on: :collection
  end

  resources :companies, :job_applications
  resources :skills do 
    post 'add_skill', on: :collection
  end

  resources :jobs do
    get 'current_company_jobs', on: :collection
  end

  post '/auth/login', to: 'authentication#login'
  post 'jobs/:job_id/apply', to: 'job_applications#apply'
  get '/suggested_jobs', to: 'users#suggested_jobs'
  get '/top_jobs', to: 'jobs#top_jobs'
  get '/all_applied_jobs', to: 'users#all_applied_jobs'
  get '/user_skills', to: 'skills#user_skills'
  get '/specific_job/:id', to: 'users#specific_job'
  get '/search_jobs_by_company_or_skill_name', to: 'jobs#search_jobs_by_company_name'
  get '/application_by_status', to: 'job_applications#application_by_status'
  get '/company_by_job_id', to: 'companies#company_by_job_id' 
  get '/search', to: 'companies#search'
end
