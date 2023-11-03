class JobApplicationsController < ApplicationController
  before_action :set_application, only: [:edit, :update, :show]

  def index
    applications = JobApplication.all
    render json: applications
  end

  def create
    job_id = params[:job_id]
    params = params[:resume]
    if job_id.present? && resume.attached?
      @job_application = current_user.job_applications.create!(job_id: job_id , resume: resume , status: "applied")
      return render json: {message: 'You have applied for the job successfully!' }, status: :created
    else
      render json: {message: "resume or job_id can't be blank"}
  rescue Exception => e
    render json: e.message
  end

  def update
    unless @current_user.id == @application.job_company.job_recruiter_id
      return render json: { message: 'you have not access to change another application' }
    end
    application.update!(set_params)
    render json: { data: @application, message: 'Job application updated successfully!' }
  rescue Exception => e
    render json: { errors: e.message }
  end

  def destroy
    unless current_user.id == @application.job_company.job_recruiter_id
      return	render json: { message: 'you have not access to change another application' }
    end
    @application.destroy!
    render json: { message: 'Job application deleted successfully!' }
  rescue Exception => e
    render json: e.message
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
    result = current_user.job_applications.applied
    return render json: { message: 'you not apply any jobs' } if result.blank?
    render json: results
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
