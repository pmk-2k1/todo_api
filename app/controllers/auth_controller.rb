class AuthController < ApplicationController
  def register
    user = User.new(user_params)
    if user.save
      token = JsonWebToken.encode(user_id: user.id)
      render json: { token: token }
    else
      render json: { errors: user.errors }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      render json: { token: token }
    else
      render json: { error: "Invalid credentials" }, status: :unauthorized
    end
  end

  private

  def user_params
    params.permit(:email, :password, :role)
  end
end