require 'sidekiq/web'

Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :jobs, only: [:index, :show]
    end
  end

  namespace :admins do
    resources :jobs do
      resources :inscriptions, only: [:index, :create, :update, :show]
    end
    resources :users, only: [:index, :update, :show, :edit] do
      get :companies_report, on: :collection
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
    resources :job_prices, only: [:update, :create]
    resources :dashboards, only: [:index]
  end

  namespace :companies do
    resources :jobs do
      get :thanks
      get :free, on: :new
      get :edit_price, on: :member
      patch :update_price, on: :member
      get :new_job_index, path: 'publicar-job', on: :collection
      get :success, on: :collection
      get :cancel, on: :collection
      get :stripe_checkout, on: :member
      resources :inscriptions, only: [:index, :create, :update, :show]
    end
    resources :dashboards, only: [:index]
  end

  namespace :candidates do
    resources :jobs, only: [:index] do
      resources :inscriptions, only: [:create]
    end
    resources :inscriptions, only: [:index]
    resources :user_profiles, only: [:show, :update]
    resources :dashboards, only: [:index]
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

  get '/sign-up-thanks', to: 'application#sign_up_thanks', as: 'sign_up_thanks'
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

  get "/jobs/:id", to: redirect("/digital-jobs/%{id}", status: 301)
  get "/jobs", to: redirect("/", status: 301)
  get '/ofertas-empleo-digital/:id', to: redirect("/es/ofertas-empleo-digital/%{id}", status: 301)
  get '/ofertas-empleo-digital', to: redirect('/', status: 301)
  get '/como-funciona/empresas', to: redirect("/es/como-funciona/empresas", status: 301)
  get '/como-funciona/talento', to: redirect('/es/como-funciona/talento', status: 301)

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  if Rails.env.production?
    constraints(host: /^(?!www\.)/i) do
      get '(*any)' => redirect { |params, request|
        URI.parse(request.url).tap { |uri| uri.host = "www.#{uri.host}" }.to_s
      }
    end
  end

  root to: redirect(path: '/es', status: 301), constraints: ->(req) { req.path == '/' && I18n.locale == :es }

  localized do
    resources :jobs, only: [:show]

    resources :how_it_works, only: [] do
      collection do
        get :companies
        get :talent
      end
    end

    resources :about_us, only: [:index]

    root to: 'jobs#index'
  end
end