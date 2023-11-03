class JobApplicationsController < ApplicationController
  include ActiveStorage::SetCurrent
  before_action :set_application, only: [:update, :show , :destroy]

  def index
    @applications = JobApplication.all
  end

  def new
    @job = Job.find_by_id(params[:job_id])
    @job_application = current_user.job_applications.new
  end

  def create
    @job_application = current_user.job_applications.new(set_params)
    @job_application.save!
    flash[:alert] = "successfully applied"
    redirect_to root_path 
  rescue Exception => e
    flash[:alert] = e.message
    redirect_to request.referer
  end

  def edit
    @application = JobApplication.find_by_id(params[:id])
  end

  def update
    @application.update!(set_params)
    flash[:alert] = "status update successfully!"
    redirect_to root_path 
  rescue Exception => e
    flash[:alert] = e.message
    redirect_to request.referer
  end

  def destroy
    @application.destroy!
    flash[:alert] = "deleted successfully!"
    redirect_to request.referer
  rescue Exception => e
    flash[:alert] = e.message
    redirect_to request.referer
  end

  def show
    @application
  end

  def application_by_status
    if params[:status]
      @applications = JobApplication.send(params[:status].downcase)
     return render json: { message: 'job application not found' } if application.blank?
    else
      @applications = JobApplication.joins(:job_seeker, :job).group(:status).pluck("status, users.name , jobs.job_title ,group_concat(job_applications.id)")  
    end
    render :index
  end

  def applied_jobs
    @applications = current_user.job_applications.applied
    render :index
  end

  private

  def set_application
    @application = JobApplication.find_by_id(params[:id])
    unless @application
      flash[:alert] = "Application Not Found" 
      redirect_to request.referer
    end
  end

  def set_params
    params.require(:job_application).permit(:job_id, :job_seeker_id, :resume, :status)
  end
end