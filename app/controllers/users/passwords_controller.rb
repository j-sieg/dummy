module Users
  class PasswordsController < ApplicationController
    def update
      if current_user.authenticate(params[:current_password])
        if current_user.update(password_params)
          redirect_to settings_url, notice: "Successfully changed your password."
        else
          respond_to do |format|
            format.turbo_stream { render partial: "replace_form", status: :unprocessable_entity }
            format.html { redirect_to settings_url, alert: "Failed to change your password." }
          end
        end
      else
        @current_password_invalid = true
        respond_to do |format|
          format.turbo_stream { render partial: "replace_form", status: :unprocessable_entity }
          format.html { redirect_to settings_url, alert: "Failed to change your password." }
        end
      end
    end

    private

    def password_params
      params.require(:user).permit(:password, :password_confirmation)
    end
  end
end
