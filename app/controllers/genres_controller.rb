class GenresController < ApplicationController
  before_action :authorize_request
  def index
    @genres = Genre.all
    
    render json: @genres, status: :ok
  end
end
