Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :genres
  resources :movies
  resources :users
  
  get '/lists/:id', to: 'lists#show'
  get '/users/:id/lists', to:'lists#show_users_lists'
  post '/auth/login', to: 'authentication#login'
  get '/*a', to: 'application#not_found'
end
