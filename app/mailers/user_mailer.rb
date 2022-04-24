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
end
