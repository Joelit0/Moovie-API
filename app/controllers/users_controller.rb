class UsersController < ApplicationController
  before_action :authorize_request, except: [:create]

  def index
    @users = User.all
    
    render json: @users.as_json(except: %i[created_at updated_at]), status: :ok
  end

  def show
    @user = User.includes(:lists).where(id: params[:id]).first
    @token_content = JsonWebToken.decode(bearer_token)
    @user_id = @token_content['user_id']

    if @user
      if @user.id == @user_id
        render json: @user.as_json(except: %i[created_at updated_at photo_path], :include => [:lists]), status: :ok
      else
        render json: { 
          message: 'You dont can see other users profile'
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

  def create
    @user = User.new(user_params)

    if @user.save
      render json: { 
        message: 'Created user',
        data: @user.as_json(except: %i[created_at updated_at photo_path])
      }, 
      status: :created
    else
      render json: { 
        message: 'User not created',
        data: @user.errors
      },
      status: :unprocessable_entity
    end
  end

  def update
    @user = User.find_by(id: params[:id])
    @token_content = JsonWebToken.decode(bearer_token)
    @user_id = @token_content['user_id']

    if @user
      if @user.id == @user_id
        if @user.update_attributes(user_params)
          render json: { 
            message: "Updated user",
            data: @user 
          },
          status: :ok
        else
          render json: {
            message: "User not updated"
          },
          status: :unprocessable_entity
        end
      else
        render json: { 
          message: 'You dont can modify other users'
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

  def destroy 
    @user = User.where(id: params[:id]).first
    @token_content = JsonWebToken.decode(bearer_token)
    @user_id = @token_content['user_id']

    if @user
      if @user.id == @user_id
        if @user.destroy
          render json: { 
            message: 'The user has been deleted'
          },
          status: :ok
        else
          render json: {
            message: 'The user could not be removed'
          },
          status: :unprocessable_entity
        end
      else
        render json: { 
          message: 'You dont can delete other users'
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

  def user_params
    params.permit(:email, :password, :password_confirmation, :full_name)
  end
  
  def bearer_token
    pattern = /^Bearer /
    header  = request.headers['Authorization']
    header.gsub(pattern, '') if header && header.match(pattern)
  end
end