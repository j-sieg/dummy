require "test_helper"

class Users::PasswordsControllerTest < ActionDispatch::IntegrationTest
  test "#new doesn't crash" do
    get forgot_my_password_url
    assert_response :success
  end

  test "#edit with a valid token" do
    user = users(:james)
    encoded_token = UserToken.create_reset_password_token(user).encoded_token

    get edit_reset_my_password_url(token: encoded_token)
    assert_response :success
  end

  test "#edit when a token has expired or is invalid" do
    user = users(:james)
    encoded_token = "dummy_token"

    get edit_reset_my_password_url(token: encoded_token)
    assert_equal "The link might have expired or is invalid.", flash[:alert]
    assert_redirected_to login_url

    encoded = UserToken.create_reset_password_token(user).encoded_token
    travel_to (1.hour.from_now + 5.seconds) do
      get edit_reset_my_password_url(token: encoded_token)
      assert_equal "The link might have expired or is invalid.", flash[:alert]
      assert_redirected_to login_url
    end
  end

  test "#update when the token has expired or is invalid" do
    user = users(:josh)
    encoded_token = "dummy_token"

    patch update_reset_my_password_url(token: encoded_token)
    assert_equal "The link might have expired or is invalid.", flash[:alert]
    assert_redirected_to login_url

    encoded_token = UserToken.create_reset_password_token(user).encoded_token

    travel_to (1.hour.from_now + 5.seconds) do
      patch update_reset_my_password_url(token: encoded_token)
      assert_equal "The link might have expired or is invalid.", flash[:alert]
      assert_redirected_to login_url
    end
  end

  test "#update when successful" do
    user = users(:josh)
    encoded_token = UserToken.create_reset_password_token(user).encoded_token
    valid_params = {
      user: {password: "sup3rSecure!", password_confirmation: "sup3rSecure!"}
    }

    # The session token and the reset password token.
    assert_difference ["user.tokens.count"], -2 do
      patch update_reset_my_password_url(token: encoded_token), params: valid_params
    end
    assert_redirected_to login_url
    assert_equal \
      "Successfully reset your password!",
      flash[:notice]
  end

  test "#create responds successfully even with a non-existent user email" do
    post forgot_my_password_url, params: {email: "non_existent_user@ecorp.com"}
    assert_emails 0
    assert_equal \
      "If your email address exists in our database, you will receive an email with instructions on how to reset your password in a few minutes.",
      flash[:notice]

    post forgot_my_password_url, params: {email: users(:james).email}
    perform_enqueued_jobs 

    assert_emails 1
    assert_equal \
      "If your email address exists in our database, you will receive an email with instructions on how to reset your password in a few minutes.",
      flash[:notice]
  end
end