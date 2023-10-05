class JobApplicationsController < ApplicationController
  before_action :set_application, only: [:update, :destroy ,:show]

  def index
    @applications = JobApplication.all
  end

  def new
    @job = Job.find_by_id(params[:job_id])
    @job_application = @job.job_applications.new
  end

  def create
    @job = Job.find_by_id(params[:job_id])
    @job_application = @job.job_applications.new(set_params)
    current_user.job_application << @job_application
    # @job_application.save
    # return render json: {message: 'You have applied for the job successfully!' }, status: :created if job_application.save
  rescue Exception => e
    render json: {errors: e.message}
  end

  def update
    unless @current_user.id == @application.job_company.job_recruiter_id
      return render json: { message: 'you have not access to change another application' }
    end
    @application.update!(status: params[:status])

    render json: { data: @application, message: 'Job application updated successfully!' }
  rescue Exception => e
    render json: { errors: e.message }
  end

  def destroy
    unless @current_user.id == @application.job_company.job_recruiter_id
      return	render json: { message: 'you have not access to change another application' }
    end
    @application.destroy!
    render json: { message: 'Job application deleted successfully!' }
  rescue Exception => e
    render json: { errors: e.message }
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

  private

  def set_application
    @application = JobApplication.find_by_id(params[:id])
    render json: { message: 'application not found' } unless @application
  end

  def set_params
    params.permit(:job_id, :job_seeker_id, :resume, :status => "applied")
  end
end
