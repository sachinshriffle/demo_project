class SkillsController < ApplicationController
  before_action :set_skill, only: [:destroy ,:update, :show]

  def index
    skills = Skill.paginate(page: params[:page], per_page: 10)
    render json: skills
  end

  def create
    @skill = Skill.create!(skill_params)
    render json: @skill , status: :created 
  rescue Exception => e
     render json: {errors: e.message , status: 422 }
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
    render json: @skill
  end

  def user_skills
    @skills = current_user.skills
    return render	json: { message: "you don't have any skill" } unless @skills

    render :index
  end
  
  def add_skill
    skill_name = params[:skill][:skills]
    skills = Skill.where(skill_name: skill_name)
    if skills.any?
      current_user.skills << skills
    	render json: {message: "skill added successfully!"}
    else
      render json: {message: "skill name not found"} unless skill
    end
  end

  private

  def skill_params
    params.require(:skill).permit(:skill_name)
  end

  def set_skill
    @skill = Skill.find_by_id(params[:id])
    render json: { message: 'Skill not found' }, status: :not_found unless @skill
  end
end
