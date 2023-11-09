require 'sidekiq/web'
Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  root "companies#index"
#   resources :users do
#     get 'user_company', on: :collection
#     get 'forgot_password', on: :collection
#     get 'reset_password', on: :collection
#   end
    
  devise_for :users
  devise_scope :user do
    get '/users/sign_out', to: 'devise/sessions#destroy'
  end
  resources :users , only: :index do
    get 'current_users' , on: :collection
  end
  
  resources :companies do
    get 'user_company' , on: :collection
    get 'company_by_job_id' , on: :collection
    # get 'search' , on: :collection
  end

  resources :job_applications do 
  	get 'applied_jobs', on: :collection
    get 'application_by_status', on: :collection
  end

  resources :skills do 
    get 'add_skill', on: :collection
    get 'user_skills', on: :collection
    get 'specific_applied_job', on: :member
  end

  resources :jobs do
    get 'current_company_jobs', on: :collection
    get 'top_jobs', on: :collection
    get 'search_jobs_by_company_or_skill_name', on: :collection
    get 'suggested_jobs', on: :collection
  end

#   post '/auth/login', to: 'authentication#login'
#   get '/suggested_jobs', to: 'users#suggested_jobs'
#   get '/top_jobs', to: 'jobs#top_jobs'
#   get '/user_skills', to: 'skills#user_skills'
#   get '/specific_job/:id', to: 'users#specific_job'
#   get '/search_jobs_by_company_or_skill_name', to: 'jobs#search_jobs_by_company_name'
#   get '/application_by_status', to: 'job_applications#application_by_status'
#   get '/company_by_job_id', to: 'companies#company_by_job_id' 
  post 'common/search', to: 'companies#search'
end
