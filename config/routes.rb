Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :genres
  resources :users
  
  get '/movies', to: "movies#index"
  get '/movies/:id', to: "movies#show"
  put '/movies/:movie_id/lists/:list_id', to:'movies#add_movie_to_a_list'
  delete '/movies/:movie_id/lists/:list_id', to:'movies#remove_movie_from_a_list'

  get '/users/:id/lists', to:'lists#index'
  get '/lists/:id', to:'lists#show'
  post '/lists', to:'lists#create'
  put '/lists/:id', to:'lists#update'
  delete '/lists/:id', to:'lists#destroy'

  post '/auth/login', to: 'authentication#login'
  get '/*a', to: 'application#not_found'
end
