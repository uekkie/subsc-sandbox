Rails.application.routes.draw do
  root to: 'books#index'

  devise_for :users, controllers: { registrations: "registrations" }

  namespace :admin do
    resources :customers, only: %i(index show)
  end

  resources :library, only:[:index]
  resources :pricing, only:[:index]
  resources :subscriptions, only: %i(new create destroy)
end
