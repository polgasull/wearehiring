require 'sidekiq/web'

Rails.application.routes.draw do
  resources :jobs do
    collection do
      get :search
      get :user_jobs
    end
  end
  devise_for :users
  root to: 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
