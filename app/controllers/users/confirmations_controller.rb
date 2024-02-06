module Users
  class ConfirmationsController < ::ApplicationController
    before_action :find_user_by_confirmation_token, only: [:edit, :update]

    def new
    end

    def create
      if user = User.unconfirmed.find_by(email: params[:email])
        user_token = UserToken.create_confirmation_token!(user)
        UserMailer.with(user: user, token: user_token.encoded_token).confirmation.deliver_later
      end

      flash[:notice] = "If your email address exists in our database, you will receive an email with instructions on how to confirm your account in a few minutes."
      redirect_to users_login_url
    end

    def edit
    end

    def update
      @user.confirm! unless @user.confirmed_at?
      @user.confirmation_tokens.delete_all

      flash[:notice] = "Successfully confirmed your account."
      redirect_to users_login_url
    end

    private

    def find_user_by_confirmation_token
      @token = params[:token]

      if @token.present? && !(@user = UserToken.find_user_by_confirmation_token(@token))
        flash[:alert] = "The link might have expired or is invalid."
        redirect_to users_login_url
      end
    end
  end
end
