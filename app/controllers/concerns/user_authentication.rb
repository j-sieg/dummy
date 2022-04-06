module UserAuthentication
  extend ActiveSupport::Concern

  included do
    helper_method :current_user
    before_action :authenticate_user
  end

  private

  def current_user
    @current_user
  end

  def authenticate_user
    @current_user ||= User.find_by_session_token(session[:user_token])
  end

  def require_user_authentication!
    unless @current_user
      store_requested_url!
      redirect_to login_url, alert: "You need to be logged in first.", status: :see_other
    end
  end

  def redirect_if_already_authenticated!
    if @current_user
      redirect_to root_url, alert: "You are already logged in.", status: :see_other
    end
  end

  def store_requested_url!
    session[:stored_location] = request.url
  end

  def stored_url
    session.delete(:stored_location)
  end
end
