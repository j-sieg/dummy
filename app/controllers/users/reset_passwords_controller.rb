module Users
  class ResetPasswordsController < ApplicationController
    skip_before_action :require_user_authentication!
    before_action :redirect_if_already_authenticated!
    before_action :find_user_by_reset_password_token, only: [:edit, :update]

    def new
    end

    def create
      if user = User.find_by(email: params[:email])
        user_token = UserToken.create_reset_password_token(user)
        UserMailer.with(user: user, token: user_token.encoded_token).reset_password.deliver_later
      end

      flash[:notice] = "If your email address exists in our database, you will receive an email with instructions on how to reset your password in a few minutes."
      redirect_to login_url
    end

    def edit
    end

    def update
      if @user.update(password_params)
        @user.tokens.delete_all
        flash[:notice] = "Successfully reset your password!"
        redirect_to login_url
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def find_user_by_reset_password_token
      @token = params[:token]

      if @token.present? && !(@user = UserToken.find_user_by_reset_password_token(@token))
        flash[:alert] = "The link might have expired or is invalid."
        redirect_to login_url
      end
    end

    def password_params
      params.require(:user).permit(:password, :password_confirmation)
    end
  end
end
