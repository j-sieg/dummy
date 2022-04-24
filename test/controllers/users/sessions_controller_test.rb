require "test_helper"

class Users::SessionsControllerTest < ActionDispatch::IntegrationTest
  test "#new doesn't crash" do
    get login_url
    assert_response :success
  end

  test "#new redirects when the user is already logged in" do
    user = users(:james)
    user_log_in_as(user)

    get login_url
    assert_equal "You are already logged in.", flash[:alert]
    assert_response :see_other
  end

  test "#create logs the user in" do
    user = users(:james)

    assert_difference "UserToken.count" do
      post login_url, params: {email: user.email, password: "It's m3?"}
    end

    assert user_logged_in?(user)
    assert_equal "Logged in successfully.", flash[:notice]
    assert_response :see_other
  end

  test "#create responds with :unprocessable_entity when invalid" do
    assert_no_difference "UserToken.count" do
      post login_url, params: {email: "nobody@example.com", password: "it's m3?"}
    end
    assert_response :unprocessable_entity
    assert_equal "Invalid email/password.", flash[:alert]

    user = users(:james)
    assert_no_difference "UserToken.count" do
      post login_url, params: {email: user.email, password: "WRONG PASSWORD"}
    end
    assert_response :unprocessable_entity
    assert_equal "Invalid email/password.", flash[:alert]
    refute user_logged_in?(user)
  end

  test "#create redirects the user to the previously requested location" do
    get settings_url
    assert_redirected_to login_url
    assert_equal "You need to be logged in first.", flash[:alert]

    user = users(:james)
    post login_url, params: {email: user.email, password: "It's m3?"}
    assert_redirected_to settings_url
    assert_equal "Logged in successfully.", flash[:notice]
  end

  test "#create doesn't log in an unconfirmed user" do
    user = users(:unconfirmed)

    assert_no_difference "UserToken.count" do
      post login_url, params: {email: user.email, password: "It's m3?"}
    end

    assert_response :unprocessable_entity
    refute user_logged_in?(user)
    assert_equal "Invalid email/password.", flash[:alert]
  end

  test "#destroy logs the user out of all sessions" do
    user = users(:james)
    user.tokens.create!(context: "session")
    user_log_in_as(user)

    assert_difference "UserToken.count", -2 do
      delete logout_url
    end
    assert_response :see_other
    assert "Logged out successfully", flash[:notice]
  end

  test "#destroy with a specific id only deletes that session" do
    user = users(:james)
    user.tokens.create!(context: "session")

    user_log_in_as(user)
    token = user.reload.active_sessions.first

    assert_difference "UserToken.count", -1 do
      delete destroy_user_session_url(token)
    end
    assert_response :see_other
  end

  test "#destroy with a specific id doesn't crash even if the id doesn't exist" do
    delete destroy_user_session_url(500_000)
    assert_response :see_other
  end

  test "#destroy doesn't need a user to be logged in" do
    delete logout_url
    assert_response :see_other
  end
end