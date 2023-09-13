class CompaniesController < ApplicationController
	before_action :set_company , only: [:update , :destroy, :show]

	def index
    companies = Company.paginate(:page => params[:page], :per_page => 5)
  	render json: companies
  end

	def create
		begin
		 company = @current_user.build_company(company_params)
		 return render json: {errors: companys.errors.full_messages} unless company.save 
		 render json: {data: company, message: "company created successfuly!"}, status: :ok
		rescue => e
			render json: {errors: e.message}
		end
	end 

	def destroy
		begin
			return render json: {message: "this is not your company"} if @current_user.id != @company.user_id
		  render json: { message: "company deleted successfully!"}
	 rescue => e
			render json: {errors: e.message}
		end
	end

	def update
		begin
		 @company.update!(company_params)
		 render json: {data: @company , message: "company updated successfuly!"}
		rescue => e
			render json: {errors: e.message}
		end 
  end

  def show 
    render json: @company
  end

	private

	def company_params
		params.permit(:company_name, :address, :contact, :user_id)
	end

	def set_company 
	  @company = Company.find_by_id(params[:id])
	  return render json: {message: "company not available"} unless @company
	end
end