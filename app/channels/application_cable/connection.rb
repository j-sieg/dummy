module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      return reject_unauthorized_connection unless (user_token = @request.session[:user_token])

      if verified_user = UserToken.find_user_by_session_token(user_token)
        verified_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
