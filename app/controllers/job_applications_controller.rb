class JobApplicationsController < ApplicationController
  skip_before_action :authorize_recruiter , except: :updated

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

  def update_status
  	application = job_application = JobApplication.find(params[:id])
  	company = application.job.company
  	return unless @current_user == company.user
    new_status = params[:status] 
    jobs = application.update(status: new_status)
    if jobs
      render json: { message: "Job application updated successfully!"}
    else
      render json: { errors: ["Invalid status"] }
    end
  end

  # private
  # def set_job_application
    
  #   render json: { message: "Job application not found" }, status: :not_found unless job_application
  #   return job_application
  # end
end
