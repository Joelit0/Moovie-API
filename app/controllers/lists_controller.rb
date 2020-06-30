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
  
  # def show
  #   @list = List.find_by(id: params[:id])

  #   if @list
  #     if @list.user_id == @current_user.id
  #       render json: @list, status: :ok
  #     else
  #       render json: { 
  #         message: "You cannot see other users' lists"
  #       },
  #       status: :unauthorized
  #     end
  #   else
  #     render json: { 
  #       message: 'The list does not exist' 
  #     },
  #     status: :not_found
  #   end
  # end

  # def create 
  #   @list = List.new(list_params).user.build(:user_id => @current_user.id)
    
  #   if @list.save
  #     render json: { 
  #       message: 'Created List',
  #       data: @list
  #     }, 
  #     status: :created
  #   else
  #     render json: { 
  #       message: 'User not created',
  #       data: @list.errors
  #     },
  #     status: :unprocessable_entity
  #   end
  # end

  # def destroy 
  #   @list = List.find_by(id: params[:id])

  #   if @list
  #     if @list.id == @current_user.id
  #       if @list.destroy
  #         render json: { 
  #           message: 'The list has been deleted'
  #         },
  #         status: :ok
  #       else
  #         render json: {
  #           message: 'The list could not be removed'
  #         },
  #         status: :unprocessable_entity
  #       end
  #     else
  #       render json: { 
  #         message: 'You cannot delete other users lists'
  #       },
  #       status: :unauthorized
  #     end
  #   else
  #     render json: { 
  #       message: 'The list does not exist'
  #     },
  #     status: :not_found
  #   end
  # end

  # private

  # def list_params
  #   params.permit(:name, :description, :public)
  # end
end
