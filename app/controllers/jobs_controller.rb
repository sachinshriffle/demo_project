class JobsController < ApplicationController
  skip_before_action :authorize_recruiter, only: :suggested_jobs

  def index
  	  jobs = Job.all
  	  render json: jobs
  end

	def create
		company = @current_user.company
		jobs = company.jobs.build(job_params)
		if jobs.save 
		  render json: {message: "job create successfuly!"}
	  else
		  render json: {errors: jobs.errors.full_messages}  
		end
	end 

	def destroy
		jobs = set_job.destroy
		render json: {message: "job delete successfuly!"}
	end

	def update
		jobs = set_job.update(jobs_params)
		render json: {message: "job update successfuly!"}
  end

  def show 
  	job = Job.find_by_id(params[:id])
  	return render json: {message: "Job not available"} unless job
  	rendr json: job
  end

  def suggested_jobs
    return unless @current_user.type == "JobSeeker"
    suggested_jobs = Job.where('required_skills IN (?)', @current_user.skills.pluck(:skills))
    render json: suggested_jobs
  end

  def top_jobs
    top_jobs = Job.joins(:job_applications).group(:id).order('COUNT(job_applications.id) DESC').limit(10)
    top_jobs = Job.top_jobs_for_recruiter(@current_user)
    render json: top_jobs
  end

	private
	def job_params
		params.permit(:job_title, :required_skills, :company_id)
	end

	def set_job
    job = Job.find_by_id(params[:id])
    unless job
      render json: { message: "Job not found" }, status: :not_found
    end
	end
end