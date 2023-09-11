class UsersController < ApplicationController
	skip_before_action :authorize_request , only: :create 
	skip_before_action :authorize_recruiter
	
	def create
		user = User.new(user_params)
		return render json: {message: "user created successfuly!"}, status: :ok if user.save
		render json: {errors: user.errors.messages}
	end 

	def destroy
		@current_user.destroy
		return render json: {message: "user deleted successfuly!"}, status: :ok
	end

	def update
    user = @current_user.update(update_params)
    render json: {data: user , message: "user updated successfuly!"}, status: :ok
  end

  def show 
  	users = @current_user.type == "JobSeeker" ? JobSeeker.all : JobRecruiter.all
    render json: users
  end

	private
	def user_params
		params.permit(:name, :mobile_number, :email, :password, :type)
	end
  
  def update_params
    params.permit(:name, :mobile_number, :password)
  end
end