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

  def logout
    token = request.headers["Authorization"]&.split(" ")&.last
    if token
      decoded = JsonWebToken.decode(token)
      exp = decoded ? Time.at(decoded[:exp]) : 24.hours.from_now
      Rails.cache.write("blacklist_#{token}", true, expires_in: (exp - Time.now))
      render json: { message: "Logged out successfully" }
    else
      render json: { error: "Missing token" }, status: :bad_request
    end
  end

  private

  def user_params
    params.permit(:email, :password, :full_name, :role)
  end
end
