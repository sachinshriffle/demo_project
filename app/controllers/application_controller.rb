class ApplicationController < ActionController::API
 before_action :authorize_request, except: [:login, :index, :show]
 before_action :authorize_recruiter, except: [:show, :index, :login]

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      decoded = JsonWebToken.decode(header)
      @current_user = User.find(decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end

  def authorize_recruiter
    if @current_user.type != "JobRecruiter"
      render json: { message: "You are not authorized for this action" }
    end
  end
end
