module Users
  class RegistrationsController < ::ApplicationController
    before_action :redirect_if_already_authenticated!

    def new
      render locals: {user: User.new}
    end

    def create
      user = User.new(user_params)

      if user.save
        user_token = UserToken.create_confirmation_token!(user)
        UserMailer.with(user: user, token: user_token.encoded_token).confirmation.deliver_later

        flash[:notice] = "You will receive email confirmation instructions in few minutes."
        redirect_to users_login_url
      else
        render :new, locals: {user: user}, status: :unprocessable_entity
      end
    end

    private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
  end
end
