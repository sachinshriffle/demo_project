class CompaniesController < ApplicationController
  before_action :set_company, only: [:update, :destroy, :show]
  skip_before_action :authorize_request , only: :company_by_job_id

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
    return render json: { message: 'this is not your company' } if @current_user.id != @company.user_id
    @company.destroy
    render json: { message: 'company deleted successfully!' }
  rescue Exception => e
    render json: { errors: e.message }
  end

  def update
  	return render json: { message: 'this is not your company' } if @current_user.id != @company.user_id
    @company.update(company_params)
    render json: { data: @company, message: 'company updated successfuly!' }
  rescue Exception => e
    render json: { errors: e.message }
  end

  def show
    render json: @company
  end

  def company_by_job_id
  	job = Job.find_by_id(params[:id])
  	return render json: {message: "job not available"} unless job
  	render json: job.company
  end
 
  private

  def company_params
    params.require(:company).permit(:company_name, :address, :contact)
  end

  def set_company
    @company = Company.find_by_id(params[:id])
    render json: { message: 'company not available' } unless @company
  end
end
