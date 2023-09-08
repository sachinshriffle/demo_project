class CompaniesController < ApplicationController

  def index
  	company = Company.all
  	render json: company
  end

	def create
		if @current_user.type == "JobRecruiter"
		 company = @current_user.build_company(company_params)
		 if company.save 
		   render json: {message: "company create successfuly!"}
		 else
		   render json: {errors: companys.errors.full_messages}
		 end
		else
			render json: {message: "you are a job seeker"}
		end
	end 

	def destroy
		if @current_user.type == "JobRecruiter"
		  company = @current_user.company.destroy
		  render json: {message: "company delete successfuly!"}
		else
			render json: {message: "you don't have a authorized to delete"}
		end
	end

	def update
    if @current_user.type == "JobRecruiter"
		  company = @current_user.company.update(company_params)
		  render json: {message: "company update successfuly!"}
		else
			render json: {message: "you don't have a authorized to update any details"}
		end
  end

  def show 
  	company = @current_user.company
  	render json: company
  end

	private
	def company_params
		params.permit(:company_name, :address, :contact, :user_id)
	end
end