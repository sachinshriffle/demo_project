class JobApplicationsController < ApplicationController
  include ActiveStorage::SetCurrent
  before_action :set_application, only: [:edit, :update, :show , :destroy]

  def index
    @applications = JobApplication.all
    # render json: @applications
  end

  def new
    @job = Job.find_by_id(params[:job_id])
    @job_application = current_user.job_applications.new
  end

  def create
    @job_application = current_user.job_applications.new(set_params)
    @job_application.save!
    flash[:alert] = "successfully applied"
    redirect_to :root_path , status: 200
    # render json: { message: 'You have applied for the job successfully!' , data: JobApplicationSerializer.new(@job_application)}, status: 200
  rescue Exception => e
    flash[:alert] = e.message
    redirect_to request.referer
    # render :new , status: 404
  end

  def edit
    @application = JobApplication.find_by_id(params[:id])
  end

  def update
    # unless @current_user.id == @application.job_company.job_recruiter_id
    #   return render json: { message: 'you have not access to change another application' }
    # end
    @application.update!(set_params)
    flash[:alert] = "status update successfully!"
    redirect_to root_path 
    # render json: { message: 'Job application updated successfully!' }, status: 200
  rescue Exception => e
    # render json: { errors: e.message }
    flash[:alert] = e.message
    redirect_to request.referer
  end

  def destroy
    # unless current_user.id == @application.job_company.job_recruiter_id
    #   return	render json: { message: 'you have not access to change another application' }
    # end
    @application.destroy!
    # flash[:alert] = "dleted successfully!"
    # redirect_to request.referer
    render json: { message: 'Job application deleted successfully!' } , status: 200
  # rescue Exception => e
    # flash[:alert] = e.message
    # render :index , status: 404
  end

  def show
    @application
  end

  def application_by_status
    if params[:status]
     application = JobApplication.send(params[:status].downcase)
     return render json: { message: 'job application not found' } if application.blank?
    else
     application = JobApplication.joins(:job_seeker, :job).group(:status).pluck("status, users.name , jobs.job_title ,group_concat(job_applications.id)")  
    end
    render json: application , status: 200
  end

  def applied_jobs
    result = current_user.job_applications.applied
    return render json: { message: 'you not apply any jobs' } , status: 404 if result.blank?
    render json: result , status: 200
  end

  private

  def set_application
    @application = JobApplication.find_by_id(params[:id])
    # render json: { message: 'application not found' } , status: 404 unless @application
    unless @application
      flash[:alert] = "Application Not Found" 
      # redirect_to request.referer
    end
  end

  def set_params
    params.require(:job_application).permit(:job_id, :job_seeker_id, :resume, :status)
  end
end