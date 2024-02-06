ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

# For faster tests, we should lower the BCrypt cost
BCrypt::Engine.cost = 1

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def user_log_in_as(user, password: "It's m3?")
    post users_login_url, params: {email: user.email, password: "It's m3?"}
  end

  def user_logged_in?(user, context = "session")
    session_token = session[:user_token]
    user.tokens.where(token: session_token, context: context).exists?
  end
end
