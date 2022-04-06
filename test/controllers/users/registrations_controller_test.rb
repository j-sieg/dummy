require "test_helper"

class Users::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "#new doesn't crash" do
    get sign_up_url
    assert_response :success
  end

  test "#create persists a new user and redirects to login page" do
    assert_difference "User.count" do
      post sign_up_url, params: {
        user: {email: "nobody@example.com", password: "it's m3?", password_confirmation: "it's m3?"}
      }
    end

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
end