require "test_helper"

class PasswordTest < ActiveSupport::TestCase
  test "it doesn't save when the current_password is incorrect" do
    password = Password.new(has_secure_password: users(:james), current_password: "invalid", password: "valid passw0rd", password_confirmation: "valid passw0rd")
    refute password.save
    refute password.errors[:password].any?
    refute password.errors[:password_confirmation].any?
    assert password.errors[:current_password].any?
  end

  test "it doesn't save when the password and confirmation don't match" do
    password = Password.new(has_secure_password: users(:james), current_password: "It's m3?", password: "valid passw0rd", password_confirmation: "valid passw1rd")
    refute password.save
    refute password.errors[:password].any?
    refute password.errors[:current_password].any?
    assert password.errors[:password_confirmation].any?
  end
end
