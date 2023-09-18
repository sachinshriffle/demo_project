class UsersController < ApplicationController
  skip_before_action :authorize_request, only: [:create, :forgot, :reset]
  skip_before_action :authorize_recruiter, except: :user_company

  def index
    users = User.paginate(page: params[:page], per_page: 5)
    render json: users
  end

  def create
    user = User.new(user_params)
    return render json: { errors: user.errors.messages } unless user.save

    render json: { message: 'user created successfuly!' }, status: :ok
  rescue Exception => e
    render json: { errors: e.message }
  end

  def destroy
    user = @current_user.destroy!

    render json: { message: 'user deleted successfuly!' }, status: :ok
  rescue Exception => e
    render json: { errors: e.message }
  end

  def update
    user = @current_user.update!(update_params)

    render json: { message: 'user updated successfuly!' }, status: :ok
  rescue Exception => e
    render json: { errors: e.message }
  end

  def show
    user = User.find_by_id(params[:id])
    return render json: { message: 'User Data Not available' } unless user

    render json: user
  end

  def user_company
    company = Company.where(user_id: @current_user.id)
    return render json: { message: 'you not create any company' } unless company.present?

    render json: company
  end

  def suggested_jobs
    return render json: { message: 'you are not a job seeker' } unless @current_user.type == 'JobSeeker'

    suggested_jobs = Job.where('required_skills in (?) ', @current_user.skills.pluck(:skill_name))
    return render json: { message: 'not available jobs for you' } if suggested_jobs.blank?

    render json: suggested_jobs
  end

  def all_applied_jobs
    return render json: { message: "you're not job seeker" } unless @current_user.type == 'JobSeeker'

    result = @current_user.job_applications.where(status: 'applied')
    return render json: { message: 'you not apply any jobs' } if result.blank?

    render json: result
  end

  def specific_job
    return render json: { message: "you're not job seeker" } unless @current_user.type == 'JobSeeker'

    job = @current_user.job_applications.find_by_id(params[:id])
    return render	json: { message: 'Job Not Found' } unless job

    render json: job
  end

  def forgot
    if params[:email].blank? # check if email is present
      return render json: {error: 'Email not present'}
    end

    @user = User.find_by(email: params[:email]) # if present find user by email

    if @user.present?
      @user.generate_password_token! #generate pass token
      UserMailer.with(user: @user).forgot_password_token.deliver_now	
      render json: {status: 'reset link sent to your email'}, status: :ok
    else
      render json: {error: ["Email address not found. Please check and try again."]}, status: :not_found
    end
  end

  def reset
    token = params[:token]

    if params[:email].blank?
      return render json: {error: 'Token not present'}
    end

    user = User.find_by(reset_password_token: token)

    if user.present? && user.password_token_valid?
      if user.reset_password!(params[:password])
        render json: {status: 'ok'}, status: :ok
      else
        render json: {error: user.errors.full_messages}, status: :unprocessable_entity
      end
    else
      render json: {error:  ["Link not valid or expired. Try generating a new link."]}, status: :not_found
    end
  end

  private

  def user_params
    params.permit(:name, :mobile_number, :email, :password, :type)
  end

  def update_params
    params.permit(:name, :mobile_number, :email)
  end
end
