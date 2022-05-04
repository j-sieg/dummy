require "test_helper"

class Users::InviteTokenControllerTest < ActionDispatch::IntegrationTest
  test "#update changes the invite_token's :token" do
    user = users(:james)
    old_invite_token = user.invite_token

    user_log_in_as(user)
    patch update_user_invite_token_url

    assert_not_equal old_invite_token.token, user.reload.invite_token.token
  end
end
