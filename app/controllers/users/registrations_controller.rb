module Users
  class RegistrationsController < ::ApplicationController
    before_action :redirect_if_already_authenticated!

    def new
      render locals: {user: User.new}
    end

    def create
      user = User.new(user_params)

      if user.save
        redirect_to login_url
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
