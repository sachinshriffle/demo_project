class CompaniesController < ApplicationController
  before_action :set_company, only: [:update, :destroy]
  # before_action :authenticate_user!
  def index
    if current_user.type == "JobRecruiter" && current_user.company.present?
      @company = current_user.company
      render :show
    else
      @companies = Company.all
    end
  end

  def new
    @company = current_user.create_company
  end

  def create
    @company = current_user.create_company!(company_params)
    redirect_to root_path
  rescue Exception => e
    render :new , status: 422
  end

  def destroy
    @company.destroy!
    render json: { message: 'company deleted successfully!' }
  rescue Exception => e
    render json: { errors: e.message }
  end

  def edit
    @company = Company.find_by_id(params[:id])
  end

  def update
    @company.update!(company_params)
    render json: { message: 'company updated successfuly!'}
  rescue Exception => e
    render :edit , status: 422
  end

  def show
  	@company = Company.find_by_id(params[:id])
    # return render json: { message: 'company not available' } , status: :not_found unless @company
    # render json: @company
  end

  def company_by_job_id
  	job = Job.find_by_id(params[:id])
  	return render json: { message: "job not available"}, status: 404 unless job
  	render json: job.company , status: 200
  end

  def user_company
    @company = current_user.company
    return render json: { message: "you have not create any company" } unless @company.present?

    render json: @company
  end

  def search
  	query = params[:search]
  	# return render json: { message: "not available"} if query.blank?
    return flash[:notice] =  "not available"if query.blank?
  	user = User.where('name like ?', "%#{query}%")
    @user = user.first
  	if @user.blank?
      @companies = Company.where('company_name like ?',"%#{query}%")  
      if @companies.blank?
  		  @skills = Skill.where('skill_name like ?',"%#{query}%")
  		  if @skills.blank?
  		    @jobs = Job.where('job_title like ?',"%#{query}%")
          if @jobs.blank?
            redirect_to :index
          else
            render "jobs/index"
          end
        else
          render "skills/index"
  		  end
      else
        render "companies/index"
  		end
    else
      render "users/show"
  	end
  	# render json: @result , status: 200
  end
 
  private

  def company_params
    params.require(:company).permit(:job_recruiter_id, :company_name, :address, :contact)
  end

  def set_company
    @company = current_user.company
    # render json: { message: 'company not available' } unless @company
  end
end
