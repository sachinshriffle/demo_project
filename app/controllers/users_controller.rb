class UsersController < ApplicationController
	
	def index
		user = JobSeeker.all
		render json: user
	end

	def create
		user = User.new(user_info)
		return render json: {message: "user create successfuly!"}, status: :ok if user.save
		render json: {errors: user.errors.messages}
	end 

	def destroy
		user = common_method
		return render json: {message: "user delete successfuly!"} if user.destroy
		render json: {message: "user not present"}
	end

	def update
    user = common_method
    if user
    	user.update(update_params)
      render json: {data: user , message: "user update successfuly!"}
    else
      render json: {message: "user not present"}
    end
  end

	private
	def user_info
		params.permit(:name, :mobile_number, :email, :password, :type)
	end

	def common_method
	 User.find_by_id(params[:id])
  end
  
  def update_params
    params.permit(:name, :mobile_number)
  end
end
