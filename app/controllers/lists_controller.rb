class ListsController < ApplicationController
  before_action :authorize_request
  
  def show_users_lists
    @user = User.where(id: params[:id]).first

    if @user
      @lists = @user.lists.as_json(:include => [:movies])
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
