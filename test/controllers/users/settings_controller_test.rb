require "test_helper"

class Users::SettingsControllerTest < ActionDispatch::IntegrationTest
  test "#index requires user authentication" do
    get users_settings_url
    assert_redirected_to users_login_url
  end

  test "#index doesn't crash" do
    user = users(:james)
    user_log_in_as(user)

    get users_settings_url
    assert_response :success
  end

  test "requesting an email change" do
    user = users(:james)
    user_log_in_as(user)

    assert_difference "user.tokens.count" do
      patch users_settings_request_email_update_url, params: {email: "new@example.com"}
    end

    perform_enqueued_jobs
    assert_emails 1
  end

  test "confirming an email change" do
    user = users(:james)
    old_email = user.email
    user_token = UserToken.create_change_email_token!(user, "new@example.com")
    assert_not_equal "new@example.com", old_email

    user_log_in_as(user)
    assert_difference "user.change_email_tokens.count", -1 do
      get users_settings_update_email_url(user_token.encoded_token)
    end

    assert_redirected_to users_settings_url
    assert_equal "Successfully changed your email.", flash[:notice]
    assert_equal "new@example.com", user.reload.email
  end

  test "other users cannot use the change email token" do
    other_user = users(:josh)
    user_token = UserToken.create_change_email_token!(users(:james), "new@example.com")

    user_log_in_as(other_user)
    assert_no_difference "UserToken.count" do
      get users_settings_update_email_url(user_token.encoded_token)
    end

    assert_redirected_to users_settings_url
    assert_equal "The email change link is invalid or it has expired.", flash[:alert]
  end
end