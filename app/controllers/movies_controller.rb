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
    @movie = Movie.includes(:videos).find_by(id: params[:id])

    if @movie
      render json: @movie, :include => [:videos], status: :ok
    else
      render json: { 
        message: 'The movie does not exist' 
      },
      status: :not_found
    end
  end
  
  def add_movie_to_a_list
    @movie = Movie.find_by(id: params[:movie_id])
    @list = List.find_by(id: params[:list_id])

    if @movie
      if @list
        if @list.user_id == @current_user.id
          if @list.movies.include? @movie
            render json: {
              message: 'The movie has already been added to this list'
            },
            status: :unprocessable_entity
          else
            if @list.movies << @movie
              render json: {
                message: "The movie has been successfully added to the list", 
                movie: @movie
              }, status: :no_content
            else
              render json: {
                message: 'The list could not be updated'
              },
              status: :unprocessable_entity
            end
          end
        else
          render json: { 
            message: "You cannot add movies to other users' lists"
          },
          status: :unauthorized
        end
      else
        render json: { 
          message: 'The list does not exist'
        },
        status: :not_found
      end
    else
      render json: { 
        message: 'The movie does not exist' 
      },
      status: :not_found
    end
  end

  def remove_movie_from_a_list
    @movie = Movie.find_by(id: params[:movie_id])
    @list = List.find_by(id: params[:list_id])

    if @movie
      if @list
        if @list.user_id == @current_user.id
          if @list.movies.include? @movie
            if @list.movies.delete(@movie)
              render json: {
                message: "The movie has been successfully removed from this list", 
              }, status: :no_content
            else
              render json: {
                message: 'The movie could not be added to the list'
              },
              status: :unprocessable_entity
            end
          else
            render json: { 
              message: "The movie is not in this list"
              },
              status: :unprocessable_entity
          end
        else
          render json: { 
            message: "You cannot delete movies from other users' lists"
          },
          status: :unauthorized
        end
      else
        render json: { 
          message: 'The list does not exist'
        },
        status: :not_found
      end
    else
      render json: { 
        message: 'The movie does not exist' 
      },
      status: :not_found
    end
  end
end
