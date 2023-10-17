class CompaniesController < ApplicationController
  before_action :set_company, only: [:edit, :update, :destroy]

  def index
    # if current_user.type == "JobRecruiter" && current_user.company.present?
    #   # render :user_company
    #   @company = current_user.company
    #   render :show
    # else
      @companies = Company.all
      # @companies = Company.paginate(page: params[:page], per_page: 5)
    # end
  end

  def new
    # @company = current_user.create_company
    @company = Company.new
  end

  def create
    # @company = current_user.create_company!(company_params)
    @company = Company.create!(company_params)
    redirect_to  root_path
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
    @company
  end

  def update
    @company.update!(company_params)
    # render json: { data: @company, message: 'company updated successfuly!'}
  rescue Exception => e
    render json: { errors: e.message }
  end

  def show
  	@company = Company.find_by_id(params[:id])
    # return render json: { message: 'company not available' } unless company
    # render json: @company
  end

  def company_by_job_id
  	job = Job.find_by_id(params[:id])
  	return render json: {message: "job not available"} unless job
  	render json: job.company
  end

  # def user_company
  #   @company = current_user.company
  #   return render json: { message: 'you not create any company' } unless company.present?

  #   render json: company
  # end

  def search 
  	query = params[:search].downcase
  	return render json: {message: "not available"} if query.nil?
  	@result = User.where('name like ?', "%#{query}%")
  	if @result.blank?
      @result = Company.where('company_name like ?',"%#{query}%")
      if @result.blank?
  		  @result = Skill.where('skill_name like ?',"%#{query}%")
  		  if @result.blank?
  		    @result = Job.where('job_title like ?',"%#{query}%")
  		  end
  		end
  	end
  	return render json: @result unless @result.blank?
  	render json: {message: "data not found"}
  end
 
  private

  def company_params
    params.require(:company).permit(:job_recruiter_id, :company_name, :address, :contact)
  end

  def set_company
    @companys = current_user.company.find_by_id(params[:company_id])
    render json: { message: 'company not available' } unless @company
  end
end
