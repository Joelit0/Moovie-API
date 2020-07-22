class ListsController < ApplicationController
  before_action :authorize_request
  
  def index
    @user = User.find_by(id: params[:id])
    @lists = @current_user.lists

    if @user
      if @user.id == @current_user.id
        render json: @lists, status: :ok
      else
        render json: { 
          message: "You cannot see other users' lists"
        },
        status: :unauthorized
      end
    else
      render json: { 
        message: 'The user does not exist' 
      },
      status: :not_found
    end
  end
  
  def show
    @list = List.find_by(id: params[:id])

    if @list
      if @list.user_id == @current_user.id
        render json: @list.as_json(:include => [:movies]), status: :ok
      else
        render json: { 
          message: "You cannot see other users' lists"
        },
        status: :unauthorized
      end
    else
      render json: { 
        message: 'The list does not exist' 
      },
      status: :not_found
    end
  end

  def create 
    @list = List.new(list_params)
    @list.user_id = @current_user.id
    
    if @list.save
      render json: { 
        message: 'Created List',
        data: @list
      }, 
      status: :created
    else
      render json: { 
        message: 'List not created',
        data: @list.errors
      },
      status: :unprocessable_entity
    end
  end

  def update
    @list = List.find_by(id: params[:id])

    if @list
      if @list.user_id == @current_user.id
        if @list.update_attributes(list_params)
          render json: { 
            message: 'Updated list',
            data: @list
          },
          status: :no_content
        else
          render json: {
            message: 'The list could not be updated'
          },
          status: :unprocessable_entity
        end
      else
        render json: { 
          message: 'You cannot update other users lists'
        },
        status: :unauthorized
      end
    else
      render json: { 
        message: 'The list does not exist'
      },
      status: :not_found
    end
  end

  def destroy 
    @list = List.find_by(id: params[:id])

    if @list
      if @list.user_id == @current_user.id
        if @list.destroy
          render json: { 
            message: 'The list has been deleted'
          },
          status: :ok
        else
          render json: {
            message: 'The list could not be removed'
          },
          status: :unprocessable_entity
        end
      else
        render json: { 
          message: 'You cannot delete other users lists'
        },
        status: :unauthorized
      end
    else
      render json: { 
        message: 'The list does not exist'
      },
      status: :not_found
    end
  end
 
  def add_movie
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

  def remove_movie
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
                message: 'The movie does not exist in this list'
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
  
  private

  def list_params
    params.permit(:name, :description, :public)
  end
end
