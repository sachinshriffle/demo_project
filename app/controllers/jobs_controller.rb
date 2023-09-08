class JobsController < ApplicationController

	def index
  	jobs = Job.all
  	render json: jobs
  end

	def create
		if @current_user.type == "JobRecruiter"
			companys = @current_user.company
		  jobs = companys.jobs.build(jobs_params)
		  if jobs.save 
		    render json: {message: "job create successfuly!"}
		  else
		    render json: {errors: jobs.errors.full_messages}
		  end
		else
			render json: {message: "you are a job seeker"}
		end
	end 

	def destroy
		if @current_user.type == "JobRecruiter"
			return unless jobs = common_method
		  jobs = jobs.destroy
		  render json: {message: "job delete successfuly!"}
		else
			render json: {message: "you don't have a authorized to delete"}
		end
	end

	def update
    if @current_user.type == "JobRecruiter"
    	return unless jobs = common_method
		  jobs = jobs.update(jobs_params)
		  render json: {message: "job update successfuly!"}
		else
			render json: {message: "you don't have a authorized to change any details	"}
		end
  end

  def show 
  	jobs = @current_user.company.jobs
  	render json: jobs
  end

	private
	def jobs_params
		params.permit(:job_title, :required_skills, :company_id)
	end

	def common_method
		jobs = Job.find_by_id(params[:id])
		if jobs
			return jobs
		else
		 render json: {message: "job Not find"}
		 return 
		end
	end
end
