class AuthenticationController < ApplicationController
  def login
    user = User.find_by(email: params[:email], password: params[:password])
    if user
      token = JsonWebToken.encode(user_id: user.id)
      time = Time.now + 24.hours.to_i
      render json: { token:, username: user.name }, status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end
end
