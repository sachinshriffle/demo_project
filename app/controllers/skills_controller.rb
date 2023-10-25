class SkillsController < ApplicationController
  before_action :set_skill, only: [:destroy ,:update]

  def index
    # @skills = Skill.paginate(page: params[:page], per_page: 10)
    @skills = Skill.all
    # render json: @skills
  end

  def new
    @skill = Skill.new
  end

  def create
    @skill = Skill.create!(skill_params)
    flash[:alert] = "skill create successfully!"
    # render json: @skill , status: :created 
    redirect_to root_path
  rescue Exception => e
    render :new , status: 422
  end

  def destroy
    @skill.destroy!
    flash[:alert] = "skill deleted successfully!"
    redirect_to request.referer
    # render json: { message: 'skill deleted successfully!' }
  rescue Exception => e
    # render json: { errors: e.message } , status: 404
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
    # return render	json: { message: "you don't have any skill" } if @skills.blank?
    if @skills.blank?
     flash[:alert] = "you dont have any skill"
     redirect_to request.referer
    end
    # render json: @skills , status: 200
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
        flash[:notice] = "Skill Created successfully!"
        redirect_to user_skills_skills_path
    	  # render json: {message: "skill added successfully!"}
      end
    end
  rescue Exception => e  
    flash[:alert] = e.message
    redirect_to request.referer
  end

  def suggested_jobs
    suggested_jobs = Job.where('required_skills like ?', "%#{current_user.skills.pluck(:skill_name)}%")
    return render json: { message: 'not available jobs for you' } , status: 404 if suggested_jobs.blank?

    render json: suggested_jobs , status: 200
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
    # render json: { message: 'Skill not found' }, status: :not_found unless @skill
  end
end
