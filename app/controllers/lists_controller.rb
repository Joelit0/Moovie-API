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
          message: "You can't see other users' lists"
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
end
