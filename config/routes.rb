require 'sidekiq/web'

Rails.application.routes.draw do

  namespace :admins do
    resources :jobs do
      resources :inscriptions, only: [:index, :create, :update, :show]
    end
    resources :users, only: [:index, :update, :show] do
      member do
        get :inscriptions
      end
    end
    resources :settings, only: [:index]
    resources :categories, only: [:update]
    resources :job_types, only: [:update]
    resources :levels, only: [:update]
    resources :skills, only: [:update, :create]
    resources :coupons, only: [:update, :create]
    resources :partners, only: [:update, :create]
  end

  namespace :companies do
    resources :jobs do
      resources :inscriptions, only: [:index, :create, :update, :show]
    end
  end

  namespace :candidates do
    resources :jobs, only: [:index] do
      resources :inscriptions, only: [:create]
    end
    resources :inscriptions, only: [:index]
    resources :user_profiles, only: [:update]
  end

  resources :jobs, path: 'ofertas-empleo-digital', only: [:index, :show] do
    collection do
      get :thanks, path: 'gracias-por-publicar'
    end
  end
    
  namespace :blog, path: '/' do
    resources :posts, path: 'blog' do
      resources :comments, only: [:create, :destroy]
    end
  end

  devise_for :users, controllers: { 
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'registrations'
  }

  devise_scope :user do
    get "companies/sign_up", to: "companies_registrations#new", as: "new_company_registration"
    post "companies", to: "companies_registrations#create", as: "company_registration"
  end

  get '/como-funciona/empresas', to: 'how_it_works#companies', as: 'how_it_works_companies'
  get '/como-funciona/candidatos', to: 'how_it_works#candidates', as: 'how_it_works_candidates'
  get '/pricing', to: 'pricing#index', as: 'pricing'
  get '/legal/aviso_legal', to: 'legal#legal_terms', as: 'legal_terms'
  get '/legal/politicas_privacidad', to: 'legal#privacy_policy', as: 'privacy_policy'
  get '/legal/politicas_cookies', to: 'legal#cookies_policy', as: 'cookies_policy'
  get '/sitemap.xml' => 'sitemaps#index', defaults: { format: 'xml' }
  get "/robots.:format", to: "home#robots"

  if Rails.env.production?
    get "/404", to: "application#not_found", as: "not_found"
    get "/422", to: "application#unacceptable", as: "unacceptable"
    get "/500", to: "application#internal_server_error", as: "internal_server_error"
  end
  get "/jobs/:id", to: redirect("/ofertas-empleo-digital/%{id}")
  get "/jobs", to: redirect("/ofertas-empleo-digital")

  authenticated :user do
    root to: 'dashboard#index', as: nil
  end
  root to: 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  if Rails.env.production?
    constraints(host: /^(?!www\.)/i) do
      get '(*any)' => redirect { |params, request|
        URI.parse(request.url).tap { |uri| uri.host = "www.#{uri.host}" }.to_s
      }
    end
  end
end