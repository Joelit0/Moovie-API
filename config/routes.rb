Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :genres

  get '/users/:id', to:'users#show'
  post '/users', to:'users#create'
  put '/users/:id', to:'users#update'
  delete'/users/:id', to:'users#destroy'
  put 'users/:id/photo_path', to:'users#update_photo_path'
  delete 'users/:id/photo_path', to:'users#remove_photo_path'

  get '/movies', to: "movies#index"
  get '/movies/:id', to: "movies#show"

  get '/users/:id/lists', to:'lists#index'
  get '/lists/:id', to:'lists#show'
  post '/lists', to:'lists#create'
  put '/lists/:id', to:'lists#update'
  delete '/lists/:id', to:'lists#destroy'
  put '/lists/:list_id/movies/:movie_id', to:'lists#add_movie'
  delete '/lists/:list_id/movies/:movie_id', to:'lists#remove_movie'

  post '/auth/login', to: 'authentication#login'
  get '/*a', to: 'application#not_found'
end
