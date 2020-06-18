class ListsController < ApplicationController
  before_action :authorize_request
  
  def show_users_lists
    @user = User.where(id: params[:id]).first
    @token_content = JsonWebToken.decode(bearer_token)
    @user_id = @token_content['user_id']

    if @user
      @lists = @user.lists.movies
      if @user.id == @user_id
        render json: {
          lists: @lists
        },
        status: :ok
      else
        render json: { 
          message: 'You dont can see other users lists'
        },
        status: :not_found
      end
    else
      render json: { 
        message: 'The user does not exist' 
      },
      status: :not_found
    end
  end
 
  private 

  def bearer_token
    pattern = /^Bearer /
    header  = request.headers['Authorization']
    header.gsub(pattern, '') if header && header.match(pattern)
  end
end
