Rails.application.routes.draw do
  get 'searches/show'
  get 'searches/index'

  root to: "searches#index"
end
