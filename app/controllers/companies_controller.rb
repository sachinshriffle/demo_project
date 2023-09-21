class CompaniesController < ApplicationController
  before_action :set_company, only: [:update, :destroy]
  skip_before_action :authorize_request , only: [:company_by_job_id, :search]

  def index
    companies = Company.paginate(page: params[:page], per_page: 5)
    render json: companies
  end

  def create
    company = @current_user.create_company(company_params)
    render json: { data: company, message: 'company created successfuly!' }, status: :ok
  rescue Exception => e
    render json: { errors: "you are not a job recruter"}
  end

  def destroy
    @company.destroy!
    render json: { message: 'company deleted successfully!' }
  rescue Exception => e
    render json: { errors: e.message }
  end

  def update
    @company.update!(company_params)
    render json: { data: @company, message: 'company updated successfuly!' }
  rescue Exception => e
    render json: { errors: e.message }
  end

  def show
  	company = Company.find_by_id(params[:id])
    return render json: { message: 'company not available' } unless company
    render json: @company
  end

  def company_by_job_id
  	job = Job.find_by_id(params[:id])
  	return render json: {message: "job not available"} unless job
  	render json: job.company
  end

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
    params.require(:company).permit(:company_name, :address, :contact)
  end

  def set_company
    @company = @current_user.company.find_by_id(params[:id])
    render json: { message: 'company not available' } unless @company
  end
end
