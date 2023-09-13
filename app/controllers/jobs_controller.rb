class JobsController < ApplicationController
	before_action :set_job , only: [:destroy , :update, :show]

  def index
  	jobs = Job.paginate(:page => params[:page], :per_page => 5)
  	render json: jobs
  end

	def create
		company = @current_user.company
		job = company.jobs.build(job_params)
		return render json: {errors: job.errors.full_messages} unless job.save 
		render json: {message: "job created successfuly!"} , status: 200
	end 

	def destroy
		return render json: {errors: @job.errors.message} unless @job.destroy
		render json: {message: "job deleted successfuly!"}
	end

	def update
		return render json: {errors: @job.errors.message} unless @job.update(jobs_params)
		render json: {message: "job update successfuly!"}
  end

  def show 
  	render json: @job
  end

  def top_jobs
    top_jobs = Job.joins(:job_applications).group(:id).order('COUNT(job_applications.id) DESC').limit(10)
    return render	json: {message: "No Applicants"} if top_jobs.blank?
    render json: top_jobs, status: :ok
  end

  def current_company_jobs
  	jobs = @current_user.company.jobs
  	return render json: {message: "this company has no jobs"}, status: :not_found if jobs.blank?
  	render	json: jobs
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