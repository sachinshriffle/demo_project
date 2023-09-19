class JobsController < ApplicationController
  before_action :set_job, only: [:destroy, :update, :show]

  def index
    jobs = Job.paginate(page: params[:page], per_page: 5)
    render json: jobs
  end

  def create
    job = @current_user&.company&.jobs&.create!(job_params)

    render json: {data: job,  message: 'job created successfuly!' }, status: 200
  rescue Exception => e
    render json: { errors: "you are not a job recruiter #{e.message}"}
  end

  def destroy
    @job.destroy!

    render json: { message: 'job deleted successfuly!' }
  rescue Exception => e
    render json: { errors: e.message }
  end

  def update
 		 @job.update!(jobs_params)

    render json: { message: 'job updated successfuly!' }
  rescue Exception => e
    render json: { errors: e.message }
  end

  def show
    render json: @job
  end

  def top_jobs
    top_jobs = Job.joins(:job_applications).select("jobs.* , count(job_applicatons)").group(:id).order('COUNT(job_applications.id) DESC').limit(10)
    return render	json: { message: 'No Applicants' } if top_jobs.blank?

    render json: top_jobs, status: :ok
  end

  def current_company_jobs
    jobs = @current_user.company.jobs
    return render json: { message: 'this company has no jobs' }, status: :not_found if jobs.blank?

    render json: jobs
  end

  def search_jobs_by_company_name
  	if params[:company_name]
      result = Job.joins(:company).where("companies.company_name ilike '%?%'", params[:company_name])
  	else
  		result = Job.joins(:company).where("jobs.required_skills ilike '%?%'", params[:skill_name])
  	end
    return render json: { message: 'job not available' }, status: :not_found if job.blank?

    render json: jobs
  end

  private

  def job_params
    params.permit(:job_title, :company_id ,required_skills: [])
  end

  def set_job
    @job = Job.find_by_id(params[:id])
    render json: { message: 'Job not found' }, status: :not_found unless @job
  end
end
