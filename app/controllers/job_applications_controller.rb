class JobApplicationsController < ApplicationController
  skip_before_action :authorize_recruiter, except: [:update, :destroy]
  before_action :set_application, only: [:update, :destroy ,:show]

  def index
    application = JobApplication.all
    render json: application
  end

  def apply
    return render json: { message: 'you are not applicable for apply a job' } unless @current_user.type == 'JobSeeker'

    job = Job.find_by_id(params[:job_id])
    resume = params[:resume]
    job_application = JobApplication.new(user: @current_user, job: job, resume: resume, status: :applied)
    return render json: { data: job_application, message: 'You have applied for the job successfully!' }, status: :created unless job_application.save

    render json: { errors: job_application.errors.full_messages }
  end

  def update
    unless @current_user == @application.job.company.user
      return render json: { message: 'you have not access to change another application' }
    end
    unless @application.update(status: params[:status])
      return render json: { errors: @application.errors.full_messages }
    end

    render json: { data: @application, message: 'Job application updated successfully!' }
  rescue Exception => e
    render json: { errors: e.message }
  end

  def destroy
    unless @current_user == @application.job.company.user
      return	render json: { message: 'you have not access to change another application' }
    end
    @application.destroy
    render json: { message: 'Job application deleted successfully!' }
  rescue Exception => e
    render json: { errors: e.message }
  end

  def show
    render json: @application
  end

  def application_by_status
    application = JobApplication.send(:params[:status].downcase)
    return render json: { message: 'job application not found' } if application.blank?

    render json: application
  end

  private

  def set_application
    @application = JobApplication.find_by_id(params[:id])
    render json: { message: 'application not found' } unless @application
  end
end
