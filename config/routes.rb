require 'sidekiq/web'

Rails.application.routes.draw do

  namespace :admins do
    resources :jobs, except: [:show] do
      resource :inscriptions, except: :index
    end
    resources :users, only: [:index, :update]
  end

  resources :jobs, :path => 'ofertas-empleo-digital' do
    resource :inscriptions, except: :index
  end
    
  resources :users, only: [] do
    member do
      get :jobs
      get :inscriptions
    end
  end 

  devise_for :users, :controllers => { omniauth_callbacks: 'users/omniauth_callbacks' }

  get '/sitemap.xml' => 'sitemaps#index', defaults: { format: 'xml' }
  get "/robots.:format", to: "pages#robots"

  match "/404", to: "errors#not_found", via: :all
  match "/422", to: "errors#unacceptable", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
  get "/jobs/:id", to: redirect("/ofertas-empleo-digital/%{id}")
  get "/jobs", to: redirect("/ofertas-empleo-digital")

  root to: 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
