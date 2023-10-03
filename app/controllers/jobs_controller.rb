class JobsController < ApplicationController
  before_action :set_job, only: [:destroy, :update, :show]

  def index
    @jobs = Job.paginate(page: params[:page], per_page: 5)
  end
 
  def new
   @job = current_user&.company&.jobs&.build
  end

  def create
    byebug
    @job = current_user&.company&.jobs&.create!(job_params)
    render :new
  rescue Exception => e
    render :new
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
  	job = Job.find_by_id(params[:id])
  	render json: { message: 'Job not found' }, status: :not_found unless job
    render json: job
  end

  def top_jobs
    top_jobs = Job.joins(:job_applications).select("jobs.* , count(job_applications.id) as job_application_count").group(:id).order('job_application_count DESC').limit(10)
    return render	json: { message: 'No Applicants' } if top_jobs.blank?

    render json: top_jobs, status: :ok
  end

  def current_company_jobs
    jobs = @current_user.company.jobs
    return render json: { message: 'this company has no jobs' }, status: :not_found if jobs.blank?

    render json: jobs
  end

  def search_jobs_by_company_or_skill_name
  	if params[:company_name]
      result = Job.joins(:company).where('companies.company_name ilike "%?%"', params[:company_name].downcase)
  	else
  		result = Job.joins(:company).where('jobs.required_skills ilike "%?%"', params[:skill_name].downcase)
  	end
    return render json: { message: 'job not available' }, status: :not_found if job.blank?

    render json: jobs
  end

  private

  def job_params
    params.require(:job).permit(:job_title, :company_id ,required_skills: [])
  end

  def set_job
    @job = @current_user.company.jobs.find_by_id(params[:id])
    render json: { message: 'Job not found' }, status: :not_found unless @job
  end
end
