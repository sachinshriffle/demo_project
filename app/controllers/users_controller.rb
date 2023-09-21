class UsersController < ApplicationController
  skip_before_action :authorize_request, only: [:create, :forgot, :reset]

  def index
    users = User.paginate(page: params[:page], per_page: 5)
    render json: users
  end

  def create
    user = User.create!(user_params)
    UserMailer.with(user: user).welcome_email.deliver_now	
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
    company = @current_user.company
    return render json: { message: 'you not create any company' } unless company.present?

    render json: company
  end

  def suggested_jobs
    suggested_jobs = Job.where('required_skills like ?', "%#{@current_user.skills.pluck(:skill_name)}%")
    return render json: { message: 'not available jobs for you' } if suggested_jobs.blank?

    render json: suggested_jobs
  end

  def all_applied_jobs
    result = @current_user.job_applications.applied
    return render json: { message: 'you not apply any jobs' } if result.blank?
    render json: result
  end

  def specific_job
    job = @current_user.job_applications.find_by_id(params[:id])
    return render	json: { message: 'Job Not Found' } unless job

    render json: job
  end

  def forgot_password
    return render json: {error: 'Email not present'} if params[:email].blank?
    @user = User.find_by(email: params[:email])

    if @user.present?
      @user.generate_password_token!
      UserMailer.with(user: @user).forgot_password_token.deliver_now	
      render json: {status: 'reset link sent to your email'}, status: :ok
    else
      render json: {message: "Email Address Not Found"}, status: :not_found
    end
  end

  def reset_password
    return render json: {error: 'Token not present'} unless token = params[:token]
    return render json: {error: 'email not present'} if params[:email].blank?

    user = User.find_by(reset_password_token: token)

    return render json: {error:  ["Link not valid or expired. Try generating a new link."]}, status: :not_found unless user.present? && user.password_token_valid?
    return render json: {status: 'successfuly!'}, status: :ok if user.reset_password!(params[:password])

    render json: {error: user.errors.full_messages}, status: :unprocessable_entity
 
  end

  private

  def user_params
    params.permit(:name, :mobile_number, :email, :password, :type)
  end

  def update_params
    params.permit(:name, :mobile_number, :email)
  end
end
