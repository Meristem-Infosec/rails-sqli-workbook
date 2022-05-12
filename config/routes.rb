Rails.application.routes.draw do
  resources :queries, only: [:index]
  resources :sessions, only: [:new, :create, :destroy]
  root to: "sessions#new"
end
