require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "reset_password works" do
    recipient = users(:james)
    email = UserMailer.with(user: recipient, token: "dummy token").reset_password

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [recipient.email], email.to
    # FIXME: when we get an actual "from" email
    assert_equal ["from@example.com"], email.from
    assert_equal "Reset your password", email.subject
  end
end
