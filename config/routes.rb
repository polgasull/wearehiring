require 'sidekiq/web'

Rails.application.routes.draw do
  resources :jobs do
    resource :inscriptions, except: :index
    collection do
      get :search
      get :user_jobs
    end
  end
  devise_for :users, :controllers => { :omniauth_callbacks => 'users/omniauth_callbacks' }
  root to: 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
