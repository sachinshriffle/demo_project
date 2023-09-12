class SkillsController < ApplicationController
	skip_before_action :authorize_recruiter 
	before_action :set_skill , only: [:destroy, :update, :show]

	def index 
		skill = Skill.all
		render json: skill
	end

	def create
		return render json: {message: "you are not a jobseeker"} unless @current_user.type == "JobSeeker"
		skill = Skill.create(skill_params)
		skill =  @current_user.skills << skill
		return render json: {data: skill , message: "skill created successfuly!"} if skill
		render json: {errors: skill.errors.messages}
	end 

	def destroy
		return unless @current_user.type == "JobSeeker" 
		skill = @skill.destroy
		return render json: {errors: skills.errors.messages} unless skill
		render json: {message: "skill deleted successfully!"}
	end

	def update
		return unless @current_user.type == "JobSeeker"
    skill = @skill.update(skill_params)
		return render json: {errors: skills.errors.messages} unless skill
		render json: {message: "skill updated successfully!"}
  end

  def show 
    render json: @skill
  end

	private

	def skill_params
		params.permit(:skill_name)
	end


	def set_skill
		@skill = Skill.find_by_id(params[:id])
		return render json: { message: "Skill not found" }, status: :not_found unless @skill
	end	
end