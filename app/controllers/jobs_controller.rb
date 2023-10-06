class JobsController < ApplicationController
  before_action :set_job, only: [:destroy, :update, :show]

  def index
    @jobs = Job.paginate(page: params[:page], per_page: 5)
  end
 
  def new
   @job = current_user&.company&.jobs&.new
  end

  def create
    @job = current_user&.company&.jobs&.new(job_params)
    @job.required_skills = params[:job][:required_skills].split(',').map(&:strip) if params[:job][:required_skills].present?
    @job.save
    redirect_to root_path
  rescue Exception => e
    render :new
  end

  def destroy
    @job.destroy!
    flash[:alert] = "job deleted successfully!"
    redirect_to request.referer 
    # render json: { message: 'job deleted successfuly!' }
  rescue Exception => e
    # render json: { errors: e.message }
    flash[:alert] = e.message
  end

  def update
 		 @job.update!(jobs_params)

    render json: { message: 'job updated successfuly!' }
  rescue Exception => e
    render json: { errors: e.message }
  end

  def show
  	@job = Job.find_by_id(params[:id])
  	render json: { message: 'Job not found' }, status: :not_found unless job
    # render json: job
  end

  def top_jobs
    top_jobs = Job.joins(:job_applications).select("jobs.* , count(job_applications.id) as job_application_count").group(:id).order('job_application_count DESC').limit(10)
    return render	json: { message: 'No Applicants' } if top_jobs.blank?

    render json: top_jobs, status: :ok
  end

  def current_company_jobs
    company = Company.find_by_id(params[:company_id])
    @jobs = company.jobs
    if @jobs.blank?
      redirect_to request.referer
      flash[:alert] = "not available jobs"
    else
      render :index
    end
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
    @job = Job.find_by_id(params[:id])
    render json: { message: 'Job not found' }, status: :not_found unless @job
  end
end
