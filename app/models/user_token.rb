class UserToken < ApplicationRecord
  belongs_to :user
  has_secure_token length: 36

  enum context: {session: "session"}
end
