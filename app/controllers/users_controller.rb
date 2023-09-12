class UsersController < ApplicationController
	skip_before_action :authorize_request , only: :create 
	skip_before_action :authorize_recruiter , except: :user_company
	
	def index
		users = User.paginate(:page => params[:page], :per_page => 2)
    render json: users
  end

	def create
		user = User.new(user_params)
		return render json: {message: "user created successfuly!"}, status: :ok if user.save
		render json: {errors: user.errors.messages}
	end 

	def destroy
		user = @current_user.destroy
		return	render josn: {errors: user.errors.messages} unless user
		render json: {message: "user deleted successfuly!"}, status: :ok
	end

	def update
    user = @current_user.update(update_params)
    return	render josn: {errors: user.errors.messages} unless user
    render json: {data: user , message: "user updated successfuly!"}, status: :ok
  end

  def show 
    user = User.find_by_id(params[:id])
    return render json: {message: "User Data Not available"} unless user 
    render json: user
  end
 
  def user_company
    company = Company.where(user_id: @current_user.id)
	  return render json: {message: "you not create any company"} unless company.present?
	  render json: company
  end	

  def suggested_jobs
    return render json: {message:"you are not a job seeker"} unless @current_user.type == "JobSeeker"
    suggested_jobs = Job.where('required_skills IN (?)', @current_user.skills.pluck("group_concat(skill_name)"))
    return render json: {message: "not available jobs for you"} unless suggested_jobs
    render json: suggested_jobs
  end 

  def all_applied_jobs
    return render json: {message: "you're not job seeker"} unless @current_user.type == "JobSeeker"
    result = JobApplication.joins(:job).where(user_id: @current_user.id).pluck("jobs.job_title")
    return render json: {message: "you not apply any jobs"} if result.blank?
    render json: result
  end 

  def specific_job
  	return render json: {message: "you're not job seeker"} unless @current_user.type == "JobSeeker"
  	job = JobApplication.find_by_id(params[:id])
    render json: job
  end


	private

	def user_params
		params.permit(:name, :mobile_number, :email, :password, :type)
	end
  
  def update_params
    params.permit(:name, :mobile_number, :password)
  end
end