Rails.application.routes.draw do
  root to: 'subscriptions#index'

  devise_for :users, controllers: { registrations: "registrations" }

  namespace :admin do
    resources :customers, only: %i(index show)
  end

  resources :pricing, only:[:index]
  resources :subscriptions, only: %i(index new create destroy)

  # API
  mount API::Root => '/api'
  mount GrapeSwaggerRails::Engine => '/swagger'

  
end
