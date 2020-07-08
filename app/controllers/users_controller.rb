class UsersController < ApplicationController
  before_action :authorize_request, except: [:create]

  def show
    @user = User.includes(:lists).find_by(id: params[:id])

    if @user
      if @user.id == @current_user.id
<<<<<<< Updated upstream
        render json: @current_user.as_json(except: %i[created_at updated_at]), status: :ok
=======
        render json: @current_user.as_json(except: %i[created_at updated_at], include: [:lists]), status: :ok
>>>>>>> Stashed changes
      else
        render json: {
          message: "You cannot see other users profile"
        },
        status: :unauthorized
      end
    else
      render json: {
        message: "The user does not exist" 
      },
      status: :not_found
    end
  end

  def create
    @user = User.new(user_params)

    if @user.save
      render json: {
        message: "Created user",
        data: @user.as_json(except: %i[created_at updated_at])
      }, 
      status: :created
    else
      render json: {
        message: "User not created",
        data: @user.errors
      },
      status: :unprocessable_entity
    end
  end

  def update
    @user = User.find_by(id: params[:id])

    if @user
      if @user.id == @current_user.id
        if @user.update_attributes(user_params)
          render json: {
            message: "Updated user",
            data: @user 
          },
          status: :no_content
        else
          render json: {
            message: "User not updated"
          },
          status: :unprocessable_entity
        end
      else
        render json: {
          message: "You cannot modify other users"
        },
        status: :unauthorized
      end
    else
      render json: {
        message: "The user does not exist"
      },
      status: :not_found
    end
  end

  def destroy 
    @user = User.find_by(id: params[:id])

    if @user
      if @user.id == @current_user.id
        if @user.destroy
          render json: {
            message: "The user has been deleted"
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
          message: "You cannot delete other users"
        },
        status: :unauthorized
      end
    else
      render json: {
        message: "The user does not exist"
      },
      status: :not_found
    end
  end

  def update_photo_path
    @user = User.find_by(id: params[:id])
    @photo_path = "photo_path"

    if @user
      if @user.id == @current_user.id
        if photo_path_params.include? @photo_path
          if @user.update_attributes(photo_path_params)
            render json: {
              message: "The photo path has been updated correctly",
              photo_path: @user.photo_path
            }, status: :ok
          else
            render json: {
              message: "The photo path could not be updated"
            },
            status: :unprocessable_entity
          end
        else
          render json: {
            message: "You must pass the parameter 'photo_path' to update it"
          }, status: :unprocessable_entity
        end
      else
        render json: {
          message: "You cannot modify other users' photo path"
        },
        status: :unauthorized
      end
    else
      render json: {
        message: "The user does not exist"
      },
      status: :not_found
    end
  end

  def remove_photo_path
    @user = User.find_by(id: params[:id])

    if @user
      if @user.id == @current_user.id
        if @user.photo_path == ""
          render json: { message: "The photo path has already been removed from this user" }, status: :unprocessable_entity
        else
          if @user.update_attributes(photo_path: "")
            render json: { message: "The photo path has been removed from this user" }, status: :ok
          else
            render json: {
              message: "The photo path could not be removed"
            },
            status: :unprocessable_entity
          end
        end
      else
        render json: {
          message: "You cannot delete other users' photo path"
        },
        status: :unauthorized
      end
    else
      render json: {
        message: "The user does not exist"
      },
      status: :not_found
    end
  end
  
  private 

  def user_params
    params.permit(:email, :password, :password_confirmation, :full_name)
  end

  def photo_path_params
    params.permit(:photo_path)
  end
end
