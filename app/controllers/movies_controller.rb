class MoviesController < ApplicationController
  def index
    attribute = params["sort_by"] || :title
    order = params["sort_order"] || :asc
    @movies = Movie.all.order(attribute => order).paginate(page: params[:page], per_page: 20)
    @movies = @movies.filter_by_title(params[:title]) if params[:title].present?
    
    # if params[:sort].present?
    #   @movies = Movie.all.order(title: params[:sort])
    # elsif params[:release_date].present?
    #   @movies = Movie.all.order(release_date: params[:release_date])
    # end

    render json: @movies, status: :ok 
  end

  def show 
    @movie = Movie.includes(:videos).where(id: params[:id])

    render json: @movie, :include => [:videos], status: :ok
  end
end