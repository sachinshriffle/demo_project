class SkillsController < ApplicationController

	def create
		if @current_user.type == "JobSeeker"
		 skills = Skill.new(skills_params)
		 return render json: {message: "skills create successfuly!"}, status: :ok if skills.save
		 render json: {errors: skills.errors.messages}
		else
			render json: {message: "you are not a jobseeker"}
		end
	end 

	def destroy
		return unless skill = common_method
		skills = skill.destroy
		render json: {message: "skills delete successfuly!"}
	end

	def update
		return unless skill = common_method
    skills = skill.update(skills_params)
    render json: {data: skills , message: "skills update successfuly!"}
  end

  def show 
  	skills = Skill.all
  	render json: skills
  end

	private
	def skills_params
		params.permit(:skills)
	end

	def common_method
		skils = Skill.find_by_id(params[:id])
		if skils
			return skills
		else
		 render json: {message: "skill Not find"}
		 return 
		end
	end
end
