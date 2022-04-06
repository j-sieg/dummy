require "test_helper"

class Users::SettingsControllerTest < ActionDispatch::IntegrationTest
  test "#index requires user authentication" do
    get settings_url
    assert_redirected_to login_url
  end

  test "#index doesn't crash" do
    user = users(:james)
    user_log_in_as(user)

    get settings_url
    assert_response :success
  end
end