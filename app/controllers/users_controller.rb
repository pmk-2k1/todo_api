class UsersController < ApplicationController
  before_action :authorize!
  before_action :admin_only!

  def index
    render json: User.all
  end

  def update
    user = User.find(params[:id])
    if user.update(user_params)
      render json: user
    else
      render json: { errors: user.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    User.find(params[:id]).destroy
    head :no_content
  end

  private

  def user_params
    params.permit(:full_name, :email, :password)
  end
end
