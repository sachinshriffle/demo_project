class UsersController < ApplicationController
	before_action :authorize_request , except: :create 
	
	def create
		user = User.new(user_params)
		return render json: {message: "user create successfuly!"}, status: :ok if user.save
		render json: {errors: user.errors.messages}
	end 

	def destroy
		@current_user.destroy
		return render json: {message: "user delete successfuly!"}
	end

	def update
    user = @current_user.update(update_params)
    render json: {data: user , message: "user update successfuly!"}
  end

  def show 
  	if @current_user.type == "JobSeeker"
  		user = JobSeeker.all
  		render json: user
  	else
  		user = JobRecruiter.all
  		render json: user
  	end
  end

	private
	def user_params
		params.permit(:name, :mobile_number, :email, :password, :type)
	end
  
  def update_params
    params.permit(:name, :mobile_number, :password)
  end
end
