class ApplicationController < ActionController::Base
  # before_action :authorize_request, except: [:login ,:index ,:show]
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :type])
  end
  # def authorize_request
  #   header = request.headers['Authorization']
  #   header = header.split(' ').last if header
  #   begin
  #     decoded = JsonWebToken.decode(header)
  #     @current_user = User.find(decoded[:user_id])
  #   rescue ActiveRecord::RecordNotFound => e
  #     render json: { errors: e.message }, status: :unauthorized
  #   rescue JWT::DecodeError => e
  #     render json: { errors: e.message }, status: :unauthorized
  #   end
  # end
end
