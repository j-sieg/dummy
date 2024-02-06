require "test_helper"

class Users::PasswordsControllerTest < ActionDispatch::IntegrationTest
  test "changing passwords" do
    user = users(:james)
    user_log_in_as(user)

    patch users_settings_passwords_url, params: {
      password: {
        current_password: "It's m3?",
        password: "n3w p4ssw0rd!",
        password_confirmation: "n3w p4ssw0rd!"
      }
    }

    assert_redirected_to users_settings_url
    assert_equal "Successfully changed your password.", flash[:notice]
  end

  test "invalid password_params" do
    user = users(:james)
    user_log_in_as(user)

    patch users_settings_passwords_url, params: {
      password: {
        current_password: "It's m3?",
        password: "n3w p4ssw0rd!",
        password_confirmation: "they don't match"
      }
    }

    assert_redirected_to users_settings_url
    assert_equal "Failed to change your password.", flash[:alert]
  end
end