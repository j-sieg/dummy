require "test_helper"

class Users::ConfirmationsControllerTest < ActionDispatch::IntegrationTest
  test "#new doesn't crash" do
    get users_confirmation_url
    assert_response :success
  end

  test "#create when the email is unconfirmed" do
    unconfirmed_user = users(:unconfirmed)
    perform_enqueued_jobs do
      post users_confirmation_url, params: {email: users(:unconfirmed).email}
    end

    assert_emails 1
    assert_redirected_to login_url
    assert_equal \
      "If your email address exists in our database, you will receive an email with instructions on how to confirm your account in a few minutes.",
      flash[:notice]
  end

  test "#create when an email doesn't exist in the database" do
    perform_enqueued_jobs do
      post users_confirmation_url, params: {email: "invalid_email@example.com"}
    end

    assert_emails 0
    assert_redirected_to login_url
    assert_equal \
      "If your email address exists in our database, you will receive an email with instructions on how to confirm your account in a few minutes.",
      flash[:notice]
  end

  test "#create when the email is confirmed" do
    perform_enqueued_jobs do
      post users_confirmation_url, params: {email: users(:james).email}
    end

    assert_emails 0
    assert_redirected_to login_url
    assert_equal \
      "If your email address exists in our database, you will receive an email with instructions on how to confirm your account in a few minutes.",
      flash[:notice]
  end

  test "#edit with a valid token" do
    user = users(:unconfirmed)
    user_token = UserToken.create_confirmation_token!(user)

    get edit_user_confirmation_url(user_token.encoded_token)
    assert_response :success
  end

  test "#edit when a token is invalid" do
    user = users(:unconfirmed)

    get edit_user_confirmation_url(token: "dummy token")
    assert_equal "The link might have expired or is invalid.", flash[:alert]
    assert_redirected_to login_url
  end

  test "#edit when a token has expired" do
    user = users(:unconfirmed)
    encoded_token = UserToken.create_confirmation_token!(user).encoded_token

    travel_to (3.days.from_now + 5.seconds) do
      get edit_user_confirmation_url(token: encoded_token)
      assert_equal "The link might have expired or is invalid.", flash[:alert]
      assert_redirected_to login_url
    end
  end

  test "#edit when a user is already confirmed" do
    user = users(:james)
    user_token = UserToken.create_confirmation_token!(user)

    get edit_user_confirmation_url(token: user_token.encoded_token)
    assert_response :success
  end

  test "#update when the token is valid" do
    user = users(:unconfirmed)
    user_token = UserToken.create_confirmation_token!(user)
    user_token = UserToken.create_confirmation_token!(user)

    refute user.confirmed_at?

    assert_difference "user.confirmation_tokens.count", -2 do
      patch update_user_confirmation_url(user_token.encoded_token)
    end

    assert_redirected_to login_url
    assert_equal "Successfully confirmed your account.", flash[:notice]
    assert user.reload.confirmed_at?
  end

  test "#update when the token is invalid" do
    user = users(:unconfirmed)
    user_token = UserToken.create_confirmation_token!(user)

    assert_no_difference "user.confirmation_tokens.count" do
      patch update_user_confirmation_url("invalid_token")
    end

    assert_redirected_to login_url
    assert_equal "The link might have expired or is invalid.", flash[:alert]
    refute user.reload.confirmed_at?
  end

  test "#update when a user is already confirmed" do
    user = users(:james)
    original_confirmed_at = user.confirmed_at
    user_token = UserToken.create_confirmation_token!(user)

    assert_difference "user.confirmation_tokens.count", -1 do
      patch update_user_confirmation_url(user_token.encoded_token)
    end

    assert_redirected_to login_url
    assert_equal "Successfully confirmed your account.", flash[:notice]
    assert_equal original_confirmed_at, user.reload.confirmed_at
  end
end