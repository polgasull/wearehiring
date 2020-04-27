require 'sidekiq/web'

Rails.application.routes.draw do
  resources :jobs do
    resource :inscriptions, except: :index
    collection do
      get :search
    end
  end
  
  resources :inscriptions, only: [:index]
  
  resources :users, only: [] do
    member do
      get :jobs
      get :inscriptions
    end
  end 

  devise_for :users, :controllers => { :omniauth_callbacks => 'users/omniauth_callbacks' }

  root to: 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
