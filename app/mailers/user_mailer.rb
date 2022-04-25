class UserMailer < ApplicationMailer
  def reset_password
    @user = params[:user]
    @token = params[:token]
    mail(to: @user.email, subject: "Reset your password")
  end

  def confirmation
    @user = params[:user]
    @token = params[:token]
    mail(to: @user.email, subject: "Confirm your account")
  end

  def update_email
    @receiver_email = params[:receiver_email]
    @token = params[:token]
    mail(to: @receiver_email, subject: "Update your email")
  end
end
