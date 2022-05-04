require "test_helper"

class UserInviteTest < ActiveSupport::TestCase
  test "level is set to the number of invited users" do
    inviter = users(:josh)
    invited = users(:rey)
    another_invited = users(:kayle)

    record = UserInvite.create!(inviter: inviter, invited: invited)
    assert_equal 1, record.level

    record = UserInvite.create!(inviter: inviter, invited: another_invited)
    assert_equal 2, record.level
  end
end
