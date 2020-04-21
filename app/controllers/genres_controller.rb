class GenresController < ApplicationController
  def index
    @genres = Genre.all
    
    render json: @genres, status: :ok
  end
end
