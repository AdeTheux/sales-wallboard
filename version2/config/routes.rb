Rails.application.routes.draw do
  resources :iframes
  root 'static#index'
  get '/sales', to: 'static#sales'
  get '/presales', to: 'static#presales'

  resources :wins
end
