class SkillsController < ApplicationController
  before_action :set_skill, only: [:edit ,:destroy ,:update]

  def index
    @skills = Skill.all
  end

  def new
    @skill = Skill.new
  end

  def create
    @skill = Skill.create!(skill_params)
    flash[:alert] = "Skill Created Successfully!"
    redirect_to request.referer
  rescue Exception => e
    render :new , status: 422
  end

  def destroy
    @skill.destroy!
    flash[:alert] = "skill deleted successfully!"
    redirect_to request.referer
  rescue Exception => e
    flash[:alert] = e.message
  end

  def edit
    @skill
  end

  def update
    @skill.update!(skill_params)
    flash[:alert] = "Skill Updated Successfully!"
    redirect_to request.referer
  rescue Exception => e
    flash[:alert] = e.message
    render :edit
  end

  def show
    skill = Skill.find_by_id(params[:id])
    return render json: { message: 'Skill not found' }, status: :not_found unless skill

    render json: skill
  end

  def user_skills
    @skills = current_user.skills
    if @skills.blank?
     flash[:alert] = "you dont have any skill"
     redirect_to request.referer
    else
      render :index
    end
     
  end
  
  def add_skill
    skill_name = params[:skills]
    skills = Skill.where(skill_name: skill_name)
    if current_user.skills.where(skill_name: skill_name).present?
      flash[:alert] = "skill are already added"
      redirect_to request.referer
    else
      if skills.present?
        current_user.skills << skills
        flash[:notice] = "Skill Added Successfully!"
        redirect_to user_skills_skills_path
      end
    end
  rescue Exception => e  
    flash[:alert] = e.message
    redirect_to request.referer
  end

  def specific_applied_job
    job = current_user.job_applications.find_by_id(params[:id])
    return render json: { message: 'Job Application Not Found' } , status: 404 unless job

    render json: job 
  end

  private

  def skill_params
    params.require(:skill).permit(:skill_name)
  end

  def set_skill
    @skill = Skill.find_by_id(params[:id])
    unless @skill
      flash[:alert] = "skill not found"
      redirect_to request.referer
    end
  end
end
