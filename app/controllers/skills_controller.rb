class SkillsController < ApplicationController
  before_action :set_skill, only: [:destroy ,:update]

  def index
    skill = Skill.paginate(page: params[:page], per_page: 10)
    render json: skill
  end

  def create
    skill = Skill.create!(skill_params)

    render json: { message: "skill created successfully!"}
  rescue Exception => e
    render json: { errors: e.message }
  end

  def destroy
    @skill.destroy!

    render json: { message: 'skill deleted successfully!' }
  rescue Exception => e
    render json: { errors: e.message }
  end

  def update
    @skill.update!(skill_params)

    render json: { message: 'skill updated successfully!' }
  rescue Exception => e
    render json: { errors: e.message }
  end

  def show
    skill = Skill.find_by_id(params[:id])
    return render json: { message: 'Skill not found' }, status: :not_found unless skill

    render json: skill
  end

  def user_skills
    skills = @current_user.skills
    return render	json: { message: "you don't have any skill" } unless skills

    render json: skills
  end
  
  def add_skill
  	skill = Skill.find_by(skill_name: params[:skill_name].downcase)
  	return render json: {message: "skill name not found"} unless skill
  	@current_user.skills << skill
  	render json: {message: "skill added successfully!"}
  rescue Exception => e
  	render json: e.message
  end

  private

  def skill_params
    params.permit(:skill_name)
  end

  def set_skill
    @skill = @current_user.skills.find_by_id(params[:id])
    render json: { message: 'Skill not found' }, status: :not_found unless @skill
  end
end
