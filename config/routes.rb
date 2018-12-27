Rails.application.routes.draw do
  root to: 'books#index'

  devise_for :users, controllers: { registrations: "registrations" }

  namespace :admin do
    resources :customers
  end
  
  resources :library, only:[:index]
  resources :pricing, only:[:index]
  resources :subscriptions
end
