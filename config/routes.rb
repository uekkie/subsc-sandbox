Rails.application.routes.draw do
  root to: 'subscriptions#index'

  devise_for :users, controllers: {
     registrations: "registrations" 
  }

  namespace :admin do
    resources :customers, only: %i(index show)
  end

  resources :pricing, only:[:index]
  resources :subscriptions, only: %i(index new create destroy) do
    get 'status', on: :collection
  end

  resources :contracts do
    get 'thanks', on: :collection
  end

  # API
  mount API::Root => '/'
  mount GrapeSwaggerRails::Engine => '/swagger'

end
