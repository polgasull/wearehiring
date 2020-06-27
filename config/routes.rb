require 'sidekiq/web'

Rails.application.routes.draw do

  namespace :admins do
    resources :jobs, except: [:show] do
      resource :inscriptions, except: :index
    end
    resources :users, only: [:index, :update] do
      member do
        get :inscriptions
      end
    end 
  end

  resources :jobs, path: 'ofertas-empleo-digital' do
    resource :inscriptions, except: :index
  end
    
  resources :users, only: [:update] do
    member do
      get :jobs
      get :inscriptions
    end
  end 

  resources :posts, path: 'blog' do
    resources :comments
  end

  devise_for :users, :controllers => { omniauth_callbacks: 'users/omniauth_callbacks' }

  get '/ofertas-empleo-digital/empleo/gracias-por-publicar', to: 'jobs#thanks', as: 'thanks_job_page'
  get '/users/acceso_candidatos', to: 'users#candidate_access', as: 'candidate_access'
  get '/legal/aviso_legal', to: 'legal#legal_terms', as: 'legal_terms'
  get '/legal/politicas_privacidad', to: 'legal#privacy_policy', as: 'privacy_policy'
  get '/legal/politicas_cookies', to: 'legal#cookies_policy', as: 'cookies_policy'
  get '/sitemap.xml' => 'sitemaps#index', defaults: { format: 'xml' }
  get "/robots.:format", to: "pages#robots"

  match "/404", to: "errors#not_found", via: :all
  match "/422", to: "errors#unacceptable", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
  get "/jobs/:id", to: redirect("/ofertas-empleo-digital/%{id}")
  get "/jobs", to: redirect("/ofertas-empleo-digital")

  root to: 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  constraints(host: /^(?!www\.)/i) do
    get '(*any)' => redirect { |params, request|
      URI.parse(request.url).tap { |uri| uri.host = "www.#{uri.host}" }.to_s
    }
  end
end