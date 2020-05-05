class MoviesController < ApplicationController
  def index
    @movies = Movie.all.order(title: :asc).paginate(page: params[:page], per_page: 20)
    @movies = @movies.filter_by_title(params[:title]) if params[:title].present?
    
    if params[:sort].present?
      @movies = Movie.all.where(nil).order(title: params[:sort])
    elsif params[:release_date].present?
      @movies = Movie.all.where(nil).order(release_date: params[:release_date])
    end

    render json: @movies, status: :ok 
  end
  
  def show 
    @movie = Movie.find(params[:id])

    render json: @movie, status: :ok
  end
end