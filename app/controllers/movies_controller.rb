class MoviesController < ApplicationController
  def index
    attribute = params["sort_by"] || :title
    order = params["sort_order"] || :asc
   
    if params[:title].present?
      @movies = Movie.filter_by_title(params[:title]) 
    else
      @movies = Movie.all.order(attribute => order).paginate(page: params[:page], per_page: 20)
    end
    
    render json: @movies, status: :ok 
  end

  def show 
    @movie = Movie.includes(:videos).where(id: params[:id])

    render json: @movie, :include => [:videos], status: :ok
  end
end