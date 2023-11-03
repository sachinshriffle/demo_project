class JobsController < ApplicationController
  before_action :set_job, only: [:destroy, :update, :show]

  def index
    @jobs = Job.all
  end
 
  def new
   @job = current_user&.company&.jobs&.new
  end

  def create
    @job = current_user&.company&.jobs&.new(job_params)
    @job.required_skills = params[:job][:required_skills].split(',').map(&:strip) if params[:job][:required_skills].present?
    @job.save!
    flash[:alert] = "job create successfully!"
    redirect_to root_path
  rescue Exception => e
    flash[:alert] = e.message
    render :new , status: 422
  end
  
  def edit
    @job = Job.find_by_id(params[:id])
  end

  def update
 		@job.update!(job_params)

    render json: { message: 'job updated successfuly!' }
  rescue Exception => e
    render json: { errors: e.message } , status: 404
  end

  def destroy
    @job.destroy!
    flash[:alert] = "job deleted successfully!"
    redirect_to request.referer 
  rescue Exception => e
    render json: { errors: e.message }, status: 404
  end
  

  def show
  	@job = Job.find_by_id(params[:id])
  	return render json: { message: 'Job not found' }, status: :not_found unless @job
    render json: @job , status: 200
  end

  def top_jobs
    @jobs = Job.joins(:job_applications).select("jobs.* , count(job_applications.id) as job_application_count").group(:id).order('job_application_count DESC').limit(10)
    render :index
  end

  def current_company_jobs
    company = Company.find_by_id(params[:company_id])
    @jobs = company.jobs
    if @jobs.blank?
      flash[:alert] = "not available jobs"
      redirect_to root_path
    else
      render :index , status: 404
    end
  end

  def search_jobs_by_company_or_skill_name
  	if params[:company_name]
      result = Job.joins(:company).where('companies.company_name like "%?%"', params[:company_name].downcase)
  	elsif params[:skill_name]
  		result = Job.joins(:company).where('jobs.required_skills like "%?%"', params[:skill_name].downcase)
    else
      result = Job.all
  	end
    render json: result , status: 200
  end

  def suggested_jobs
    skills = current_user.skills.select(:skill_name)
    skills.each do |skill|
      @jobs = Job.where('required_skills like ?', "%#{skill.skill_name}%")
    end
    if @jobs.blank?
      flash[:alert] = "jobs are not match for you"
      redirect_to request.referer
    else
      render "jobs/index"
    end
  end
  
  private

  def job_params
    params.require(:job).permit(:job_title, :company_id ,required_skills: [])
  end

  def set_job
    @job = Job.find_by_id(params[:id])
    unless @job
      flash[:alert] = "job not found"
      redirect_to request.referer   
    end   
  end
end
