class MoviesController < ApplicationController
  def index
    @movies = Movie.all.order(title: :asc).paginate(page: params[:page], per_page: 20)
    @movies = @movies.filter_by_title(params[:title]) if params[:title].present?
    
    if params[:sort].present?
      @movies = Movie.all.where(nil).order(title: params[:sort])
      
      render json: @movies, status: :ok
    else
      render json: @movies, status: :ok
    end
    
    if params[:release_date].present?
      @movies = Movie.all.where(nil).order(release_date: params[:release_date])

  end
  def show 
    @movie = Movie.find(params[:id])

    render json: @movie, status: :ok
  end
end
