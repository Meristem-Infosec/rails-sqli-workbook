Rails.application.routes.draw do
  get 'searches/show'
  root to: "searches#index"
end
