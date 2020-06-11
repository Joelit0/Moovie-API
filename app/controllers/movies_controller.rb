class MoviesController < ApplicationController
  before_action :authorize_request

  def index
    attribute = params["sort_by"] || :title
    order = params["sort_order"] || :asc
   
    if params[:title].present?
      @movies = Movie.filter_by_title(params[:title]).order(attribute => order).paginate(page: params[:page], per_page: 20)
    else
      @movies = Movie.all.order(attribute => order).paginate(page: params[:page], per_page: 20)
    end
    
    render json: @movies, status: :ok 
  end

  def show 
    @movie = Movie.includes(:videos).where(id: params[:id]).first

    if @movie
      render json: @movie, :include => [:videos], status: :ok
    else
      render json: { status: 'ERROR', message: 'The movie does not exist' }, status: :not_found
    end
  end
end