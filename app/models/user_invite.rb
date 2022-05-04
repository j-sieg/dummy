class UserInvite < ApplicationRecord
  belongs_to :inviter, class_name: "User"
  belongs_to :invited, class_name: "User"

  before_create :set_level

  private

  def set_level
    self.level = (inviter.invited_users.count + 1)
  end
end
