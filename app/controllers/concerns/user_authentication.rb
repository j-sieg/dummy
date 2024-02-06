module UserAuthentication
  extend ActiveSupport::Concern

  included do
    helper_method :current_user, :user_signed_in?
    before_action :authenticate_user
  end

  private

  def current_user
    @current_user
  end

  def authenticate_user
    if token = session[:user_token]
      @current_user = UserToken.find_user_by_session_token(token)
    end
  end

  def require_user_authentication!
    unless @current_user
      store_requested_url!
      redirect_to users_login_url, alert: "You need to be logged in first.", status: :see_other
    end
  end

  def redirect_if_already_authenticated!
    if @current_user
      redirect_to root_url, alert: "You are already logged in.", status: :see_other
    end
  end

  def user_signed_in?
    @current_user.present?
  end

  def store_requested_url!
    session[:users_stored_location] = request.url
  end

  def stored_url
    session.delete(:users_stored_location)
  end
end
