class UserMailer < ApplicationMailer
	default from: 'sachinp@shriffle.com'

  def welcome_email
    @user = params[:user]
    return unless @user.email

    mail(to: @user.email, subject: 'Welcome to My Awesome Site')
  end

  def forgot_password_token
    @user = params[:user]
    return unless @user.email

    mail(to: @user.email, subject: 'Forgot Password Token')
  end
end
