class JobsController < ApplicationController

  def index
  	  jobs = Job.all
  	  render json: jobs
  end

	def create
		company = @current_user.company
		jobs = company.jobs.build(job_params)
		return render json: {errors: jobs.errors.full_messages} unless jobs.save 
		render json: {message: "job created successfuly!"} , status: 200
	end 
 

	def destroy
		job = @job.destroy
		return render json: {errors: job.errors.message} unless job
		render json: {message: "job deleted successfuly!"}
	end

	def update
		job = @job.update(jobs_params)
		return render json: {errors: job.errors.message} unless job
		render json: {message: "job update successfuly!"}
  end

  def show 
  	rendr json: @job
  end

  def top_jobs
    top_jobs = JobApplication.joins(:job).group(:id).order('COUNT(job_applications.id) DESC').limit(10)
    return render	json: {message: "jobs are not available"} unless top_jobs
    render json: top_jobs, status: :ok
  end

	private
	def job_params
		params.permit(:job_title, :required_skills, :company_id)
	end

	def set_job
    @job = Job.find_by_id(params[:id])
    return render json: { message: "Job not found" }, status: :not_found unless @job
	end
end