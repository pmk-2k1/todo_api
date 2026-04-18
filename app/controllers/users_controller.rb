class UsersController < ApplicationController
  before_action :authorize!
  before_action :admin_only!, except: [:me, :update_me]

  def me
    render json: current_user.as_json(except: [:password_digest])
  end

  def update_me
    if params[:password].present?
      unless current_user.authenticate(params[:current_password])
        return render json: { errors: { current_password: ['is incorrect'] } }, status: :unprocessable_entity
      end
    end

    if current_user.update(update_me_params)
      render json: current_user.as_json(except: [:password_digest])
    else
      render json: { errors: current_user.errors }, status: :unprocessable_entity
    end
  end

  def index
    users = User.includes(:tasks).all
    render json: users, include: :tasks
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

  def update_me_params
    params.permit(:full_name, :email, :password, :password_confirmation)
  end
end
