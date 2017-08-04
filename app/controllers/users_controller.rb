class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: :create

  def create
    existing_user = User.where(email: user_params[:email]).take
    if existing_user
      render json: { error: 'User Exists' }, status: 200
    else
      if user = User.create(user_params)
        head :ok
      else
        render json: { error: 'Not Created' }, status: 200
      end
    end
  end

  def destroy
    if  @current_user.destroy
      head :ok
    else
      render json: { error: 'Not Deleted' }, status: 200
    end
  end

  def update
    if current_user.update(user_params)
      render json: @current_user.as_json(:except => [:password_digest])
    else
      render json: { error: 'Not Updated' }, status: 200
    end
  end

  def show
    render json: @current_user.as_json(:except => [:password_digest])
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password)
    end

end
