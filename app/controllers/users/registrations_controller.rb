module Users
  class RegistrationsController < ::ApplicationController
    before_action :redirect_if_already_authenticated!
    before_action :set_user_from_invite_token
    helper_method :invalid_invite_token?, :valid_invite_token?

    def new
      render locals: {user: User.new}
    end

    def create
      user = User.new(user_params)

      if user.save
        user_token = UserToken.create_confirmation_token!(user)
        UserMailer.with(user: user, token: user_token.encoded_token).confirmation.deliver_later

        if @inviter
          UserInvite.create!(invited: user, inviter: @inviter)
        end

        flash[:notice] = "You will receive email confirmation instructions in few minutes."
        redirect_to login_url
      else
        render :new, locals: {user: user}, status: :unprocessable_entity
      end
    end

    private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end

    def set_user_from_invite_token
      if (@invite_token = params[:invite_token])
        @inviter = UserToken.find_user_by_invite_token(@invite_token)
      end
    end

    def invalid_invite_token?
      @invite_token.present? && @inviter.blank?
    end

    def valid_invite_token?
      @invite_token.present? && @inviter.present?
    end
  end
end