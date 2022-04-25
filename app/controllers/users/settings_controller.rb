module Users
  class SettingsController < ApplicationController
    before_action :find_change_email_token, only: [:update_email]

    def edit
      render locals: {active_sessions: current_user.active_sessions}
    end

    def request_email_update
      new_email = params[:email]

      error_message =
        if new_email == current_user.email
          error_message = "That is already your email!"
        elsif User.where(email: new_email).exists?
          error_message = "Email is already taken."
        end

      if error_message
        redirect_to settings_url, alert: error_message
      else
        user_token = UserToken.create_change_email_token!(current_user, new_email)
        UserMailer.with(receiver_email: new_email, token: user_token.encoded_token).update_email.deliver_later
        redirect_to settings_url, notice: "A link to confirm your email has been sent to the new address."
      end
    end

    def update_email
      current_user.update_column :email, @user_token.sent_to
      current_user.change_email_tokens.delete_all
      redirect_to settings_url, notice: "Successfully changed your email."
    end

    private

    def find_change_email_token
      token = params[:token]
      @user_token = UserToken.find_record_by_user_change_email_token(current_user, token)

      unless @user_token
        redirect_to settings_url, alert: "The email change link is invalid or it has expired."
      end
    end
  end
end
