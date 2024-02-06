require "test_helper"

class Users::ResetPasswordsControllerTest < ActionDispatch::IntegrationTest
  test "#new doesn't crash" do
    get users_forgot_my_password_url
    assert_response :success
  end

  test "#create with a non-existent user email" do
    post users_forgot_my_password_url, params: {email: "non_existent_user@ecorp.com"}

    perform_enqueued_jobs
    assert_emails 0
    assert_equal \
      "If your email address exists in our database, you will receive an email with instructions on how to reset your password in a few minutes.",
      flash[:notice]
  end

  test "#create when a user is unconfirmed" do
    user = users(:unconfirmed)
    post users_forgot_my_password_url, params: {email: user.email}

    perform_enqueued_jobs
    assert_emails 0
    assert_equal \
      "If your email address exists in our database, you will receive an email with instructions on how to reset your password in a few minutes.",
      flash[:notice]
  end

  test "#create when a user is confirmed" do
    user = users(:james)
    post users_forgot_my_password_url, params: {email: user.email}

    perform_enqueued_jobs
    assert_emails 1
    assert_equal \
      "If your email address exists in our database, you will receive an email with instructions on how to reset your password in a few minutes.",
      flash[:notice]
  end

  test "#edit with a valid token" do
    user = users(:james)
    encoded_token = UserToken.create_reset_password_token!(user).encoded_token

    get users_edit_reset_my_password_url(token: encoded_token)
    assert_response :success
  end

  test "#edit when a token is invalid" do
    get users_edit_reset_my_password_url(token: "invalid token")
    assert_redirected_to users_login_url
    assert_equal "The link might have expired or is invalid.", flash[:alert]
  end

  test "#edit when a token has expired" do
    user = users(:james)
    encoded_token = UserToken.create_reset_password_token!(user).encoded_token

    travel_to (1.hour.from_now + 5.seconds) do
      get users_edit_reset_my_password_url(token: encoded_token)
      assert_redirected_to users_login_url
      assert_equal "The link might have expired or is invalid.", flash[:alert]
    end
  end

  test "#update when the token is invalid" do
    patch users_update_reset_my_password_url(token: "dummy token")
    assert_equal "The link might have expired or is invalid.", flash[:alert]
    assert_redirected_to users_login_url
  end

  test "#update when the token has expired" do
    user = users(:josh)
    encoded_token = UserToken.create_reset_password_token!(user).encoded_token

    travel_to (1.hour.from_now + 5.seconds) do
      patch users_update_reset_my_password_url(token: encoded_token)
      assert_equal "The link might have expired or is invalid.", flash[:alert]
      assert_redirected_to users_login_url
    end
  end

  test "#update when successful" do
    user = users(:josh)
    encoded_token = UserToken.create_reset_password_token!(user).encoded_token
    valid_params = {
      user: {password: "sup3rSecure!", password_confirmation: "sup3rSecure!"}
    }

    # The session token and the reset password token.
    assert_difference ["user.tokens.count"], -2 do
      patch users_update_reset_my_password_url(token: encoded_token), params: valid_params
    end
    assert_redirected_to users_login_url
    assert_equal \
      "Successfully reset your password!",
      flash[:notice]
  end
end