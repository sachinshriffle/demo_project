class SkillsController < ApplicationController
	skip_before_action :authorize_recruiter 
	before_action :set_skill , only: [:destroy, :update]

	def index 
		skill = Skill.paginate(:page => params[:page], :per_page => 10)
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
		return render json: {message: "skill "} unless @skill.destroy
		render json: {message: "skill deleted successfully!"}
	end

	def update
		return render json: {errors: @skill.errors.full_messages} unless @skill.update(skill_params)
		render json: {message: "skill updated successfully!"}
  end

  def show 
  	skill = Skill.find_by_id(params[:id])
  	return render json: { message: "Skill not found" }, status: :not_found unless skill
    render json: skill
  end 

  def user_skills
  	skills = @current_user.skills
  	return render	json: {message: "you don't have any skill"} unless skills
    render json: skills
  end

	private

	def skill_params
		params.permit(:skill_name)
	end


	def set_skill
		@skill = @current_user.skills.find_by_id(params[:id])
		return render json: { message: "Skill not found" }, status: :not_found unless @skill
	end	
end