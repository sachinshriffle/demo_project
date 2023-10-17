class SkillsController < ApplicationController
  before_action :set_skill, only: [:destroy ,:update]

  def index
    @skills = Skill.paginate(page: params[:page], per_page: 10)
  end

  def new
    @skill = Skill.new
  end

  def create
    @skill = Skill.create!(skill_params)
      # flash[:alert] = "skill create successfully!"
    render json: @skill , status: :created 
      # redirect_to root_path
  rescue Exception => e
     render :new , status: 422
  end

  def destroy
    @skill.destroy!
    flash[:alert] = "skill deleted successfully!"
    redirect_to request.referer
    # render json: { message: 'skill deleted successfully!' }
  rescue Exception => e
    # render json: { errors: e.message }
    flash[:alert] = e.message
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
    @skills = current_user.skills
    return render	json: { message: "you don't have any skill" } unless @skills

    render :index
  end
  
  def add_skill
    # render(:partial => 'skills/add_skill')
    skill_name = params[:skill][:skills]
    skills = Skill.where(skill_name: skill_name)
    if skills.any?
      current_user.skills << skills
      # redirect_to request.referer
    else
      # redirect_to request.referer
    	# return render json: {message: "skill name not found"} unless skill
    	# render json: {message: "skill added successfully!"}
    end
  rescue Exception => e
  	# render json: e.message\
    flash[:alert] = e.message
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
