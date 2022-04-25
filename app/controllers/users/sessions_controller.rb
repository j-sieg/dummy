module Users
  class SessionsController < ::ApplicationController
    include UserAuthentication
    before_action :redirect_if_already_authenticated!, only: [:new, :create]

    def new
    end

    def create
      if (user = User.confirmed.find_by(email: params[:email])&.authenticate(params[:password]))
        redirect_url = stored_url || root_url
        reset_session
        token = UserToken.create_session_token!(user)
        session[:user_token] = token
        redirect_to redirect_url, notice: "Logged in successfully."
      else
        flash.now[:alert] = "Invalid email/password."
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      if (token_id = params[:id])
        token = @current_user&.active_sessions&.find_by(id: token_id)&.destroy
        respond_to do |format|
          format.turbo_stream { render locals: {token: token} } if token
          format.html { redirect_to settings_url, notice: "Successfully removed the session" }
        end
      else
        @current_user&.active_sessions&.delete_all
        reset_session
        redirect_to login_url, notice: "Logged out successfully."
      end
    end
  end
end
