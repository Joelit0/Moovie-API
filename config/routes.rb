Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :genres
  resources :movies

  get '/users/:id', to:'users#show'
  post '/users', to:'users#create'
  put '/users/:id', to:'users#update'
  delete'/users/:id', to:'users#destroy'
  put 'users/:id/photo_path', to:'users#add_photo_path'
  delete 'users/:id/photo_path', to:'users#remove_photo_path'

  
  get '/users/:id/lists', to:'lists#index'
  post '/auth/login', to: 'authentication#login'
  get '/*a', to: 'application#not_found'
end
