require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "password validation" do
    user = users(:james)
    user.password = "short"
    refute user.valid?

    user.password = "this password is too long. it's more than 72 characters which BCrypt cannot support."
    refute user.valid?

    user.password = "just the right mix"
    assert user.valid?
  end
end
