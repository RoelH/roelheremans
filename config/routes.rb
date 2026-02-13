Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  root "works#index"
  resources :works, only: %i[index show]

    get 'cv', to: 'profil#cv'
    get 'about', to: 'profil#about'
    get 'contact', to: 'profil#contact'

  get 'newsletter', to: 'profil#newsletter'

  get 'innerportrait/:slug', to: 'inner_portraits#show', as: :inner_portrait
  post 'innerportrait/:slug/check_password', to: 'inner_portraits#check_password', as: :check_password


  # Prompt archive
  get 'prompt', to: 'prompt#index'
  post 'prompt/submit', to: 'prompt#submit', as: :prompt_submit
  get 'prompt_database', to: 'prompt#database'

  # Define the root path route ("/")

  # Defines the root path route ("/")
  # root "posts#index"
end
