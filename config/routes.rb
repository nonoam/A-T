Rails.application.routes.draw do
  root "services#index"
  
  devise_for :users
  
  resources :services do
    resources :bookings, only: [:new, :create]
  end
  
  resources :bookings, only: [:index, :show, :update]

  namespace :admin do
    resources :dashboard, only: [:index]
    resources :users, only: [:index, :destroy]
  end
end