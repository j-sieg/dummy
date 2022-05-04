require "test_helper"

class Users::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "#new doesn't crash" do
    get sign_up_url
    assert_response :success
  end

  test "#new with a valid invite token" do
    inviter = users(:james)
    invite_token = inviter.invite_token.token

    get sign_up_url(invite_token: invite_token)
    assert_response :success

    assert_select "p", text: "Signing up with #{inviter.email}'s invite code."
  end

  test "#new with an invalid invite token" do
    get sign_up_url(invite_token: "something that doesn't exist")
    assert_response :success

    assert_select "p", text: "Invite code is invalid."
  end

  test "#create persists a new user and redirects to login page" do
    assert_difference ->{ User.count } => 1, ->{ UserInvite.count } => 0 do
      post sign_up_url, params: {
        user: {email: "nobody@example.com", password: "it's m3?", password_confirmation: "it's m3?"}
      }
    end
    perform_enqueued_jobs
    assert_emails 1

    assert_redirected_to login_url
  end

  test "#create responds with :unprocessable_entity when invalid" do
    assert_no_difference "User.count" do
      post sign_up_url, params: {
        user: {email: "nobody@example.com", password: "it's m3?", password_confirmation: "doesn't match"}
      }
    end
    assert_response :unprocessable_entity
  end

  test "#create with an invite token" do
    inviter = users(:james)
    invite_token = inviter.invite_token.token

    assert_difference "inviter.invited_users.count" do
      post sign_up_url(invite_token: invite_token), params: {
        user: {email: "nobody@example.com", password: "it's m3?", password_confirmation: "it's m3?"}
      }
    end
    perform_enqueued_jobs
    assert_emails 1

    assert_redirected_to login_url
  end

  test "#create with an invalid invite token and valid credentials" do
    assert_difference ->{ User.count } => 1, ->{ UserInvite.count } => 0 do
      post sign_up_url(invite_token: "invalid token"), params: {
        user: {email: "nobody@example.com", password: "it's m3?", password_confirmation: "it's m3?"}
      }
    end
    perform_enqueued_jobs
    assert_emails 1

    assert_redirected_to login_url
  end

  test "#create with invalid invite token and credentials" do
    assert_no_difference ["User.count", "UserInvite.count"] do
      post sign_up_url(invite_token: "invalid token"), params: {
        user: {email: "nobody@example.com", password: "it's m3?", password_confirmation: "non-matching"}
      }
    end
    perform_enqueued_jobs
    assert_emails 0

    assert_response :unprocessable_entity
  end
end