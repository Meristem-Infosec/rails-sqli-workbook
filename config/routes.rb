Rails.application.routes.draw do
  get 'searches/show'
  get 'searches/index'

  resources :sessions, only: [:new, :create, :destroy]
  root to: "sessions#new"
end
