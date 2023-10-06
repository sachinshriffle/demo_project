class JobApplicationsController < ApplicationController
  before_action :set_application, only: [:edit, :update, :show]

  def index
    @applications = JobApplication.all
  end

  def new
    @job = Job.find_by_id(params[:job_id])
    @job_application = current_user.job_applications.new
  end

  def create
    @job_application = current_user.job_applications.new(set_params)
    # current_user.job_application << @job_application
    @job_application.save!
    flash[:alert] = "successfully applied"
    render :root_path
    # return render json: {message: 'You have applied for the job successfully!' }, status: :created if job_application.save
  rescue Exception => e
    flash[:alert] = e.message
    render :root_path
  end

  def edit
    @application
  end

  def update
    # unless @current_user.id == @application.job_company.job_recruiter_id
    #   return render json: { message: 'you have not access to change another application' }
    # end
    # byebug
    @application.update!(set_params)
    flash[:alert] = "status update successfully!"
    redirect_to root_path 
    # render json: { data: @application, message: 'Job application updated successfully!' }
  rescue Exception => e
    # render json: { errors: e.message }
    flash[:alert] = e.message
    render :edit
  end

  def destroy
    # unless current_user.id == @application.job_company.job_recruiter_id
    #   return	render json: { message: 'you have not access to change another application' }
    # end
    @application.destroy!
    flash[:alert] = "dleted successfully!"
    redirect_to request.referer
    # render json: { message: 'Job application deleted successfully!' }
  rescue Exception => e
    flash[:alert] = e.message
    render :index
  end

  def show
    render json: @application
  end

  def application_by_status
    if params[:status]
     application = JobApplication.send(params[:status].downcase)
     return render json: { message: 'job application not found' } if application.blank?
    else
     application = JobApplication.joins(:job_seeker, :job).group(:status).pluck("status, users.name , jobs.job_title ,group_concat(job_applications.id)")  
    end
    render json: application
  end

  def applied_jobs
    @applications = current_user.job_applications.applied
    # return render json: { message: 'you not apply any jobs' } if result.blank?
    render :index
  end

  private

  def set_application
    @application = JobApplication.find_by_id(params[:id])
    render json: { message: 'application not found' } unless @application
  end

  def set_params
    params.require(:job_application).permit(:job_id, :job_seeker_id, :resume, :status)
  end
end
