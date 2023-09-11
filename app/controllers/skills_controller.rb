class SkillsController < ApplicationController
	skip_before_action :authorize_recruiter 

	def index 
		job = Job.all
		render json: job 
	end

	def create
		return render json: {message: "you are not a jobseeker"} unless @current_user.type == "JobSeeker"
		skill = Skill.create(skills_params)
		skill =  @current_user.skills << skill
		return render json: {data: skill , message: "skills create successfuly!"} if skill
		render json: {errors: skills.errors.messages}
	end 

	def destroy
		return unless @current_user.type == "JobSeeker"
		skill = @current_user.skills.find_by_id(params[:id])
		return render json: { message: "Skill not found" }, status: :not_found unless skill
		skills = skill.destroy
		render json: {message: "skills delete successfuly!"}
	end

	def update
		return unless @current_user.type == "JobSeeker"
		skill = @current_user.skills.find_by_id(params[:id])
		return render json: { message: "Skill not found" }, status: :not_found unless skill
    skills = skill.update(skills_params)
    render json: {message: "skills update successfuly!"}
  end

  def show 
    skills = Skill.find_by_id(params[:id])
    return render json: {message: "Skill not found"} unless skills
    render json: skills
  end

	private
	def skills_params
		params.permit(:skills)
	end
end