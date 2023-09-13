class JobApplicationsController < ApplicationController
  skip_before_action :authorize_recruiter , except: [:update, :destroy]
  before_action :set_application , only: [:update , :destroy, :show]

  def index
  	application = JobApplication.all
  	render json: application
  end

  def apply
  	return render json: {message: "you are not applicable for apply a job"} unless @current_user.type == "JobSeeker"
    job = Job.find_by_id(params[:job_id])
    job_application = JobApplication.new(user: @current_user, job: job, status: :applied)
    return render json: { data: job_application, message: "You have applied for the job successfully!" }, status: :created if job_application.save
    render json: { errors: job_application.errors.full_messages }
  end

  def update
  	return render json: {message: "you have not access to change another application"} unless @current_user == @application.job.company.user
    return render json: {errors: @application.errors.full_messages} unless @application.update(status: params[:status])
    render json: {data: @application, message: "Job application updated successfully!"}
  end

  def destroy
  	begin
      return	render json: {message: "you have not access to change another application"} unless @current_user == application.job.company.user
      @application.destroy
      render json: {message: "Job application deleted successfully!"}
    rescue => e
			render json: {errors: e.message}
		end 
  end

  def show 
  	render json: @application
  end

  private 

  def set_application
  	@application = JobApplication.find_by_id(params[:id])
  	return render json: {message: "application not found"} unless @application
  end

end
