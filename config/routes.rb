Rails.application.routes.draw do
  resources :queries, only: [:index]
  resources :sessions, only: [:new, :create, :destroy, :reset]
  root to: "sessions#new"
  get "/reset", to: "sessions#reset"
end
