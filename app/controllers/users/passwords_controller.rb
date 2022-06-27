module Users
  class PasswordsController < ApplicationController
    def update
      password = Password.new(password_params.merge({has_secure_password: current_user}))
      if password.save
        redirect_to settings_url, notice: "Successfully changed your password."
      else
        respond_to do |format|
          format.html { redirect_to settings_url, alert: "Failed to change your password." }
          format.turbo_stream do
            render locals: {password: password}, status: :unprocessable_entity
          end
        end
      end
    end

    private

    def password_params
      params.require(:password).permit(:current_password, :password, :password_confirmation)
    end
  end
end
