Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :genres
  resources :movies
  resources :users
  
  get '/users/:id/lists', to:'lists#index'
  get '/lists/:id', to:'lists#show'
  post '/auth/login', to: 'authentication#login'
  get '/*a', to: 'application#not_found'
end
