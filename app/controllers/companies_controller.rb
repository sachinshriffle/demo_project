class CompaniesController < ApplicationController

	def index
    companies = Company.all
  	render json: companies
  end

	def create
		company = @current_user.build_company(company_params)
		if company.save 
		  render json: {data: company, message: "company created successfuly!"}, status: :ok
		else
		  render json: {errors: companys.errors.full_messages}
		end
	end 

	def destroy
		company = Company.find_by_id(params[:id])
		company.destroy
		render json: {message: "company deleted successfully!"}
	end

	def update
		company = Company.find_by_id(params[:id])
		company = @current_user.company.update(company_params)
		return render json: {message: "company updated successfuly!"} if company
		render json: {errors: company.errors.full_messages}
  end

  def show 
    company = Company.find_by_id(params[:id])
    return render json: {message: "company not found"} unless company
    render json: company
  end

	private

	def company_params
		params.permit(:company_name, :address, :contact, :user_id)
	end
end