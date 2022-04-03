class User < ApplicationRecord
  has_secure_password
  has_many :tokens, class_name: "UserToken"

  def generate_session_token!
    token = SecureRandom.bytes(32)
    tokens.create!(context: "session", token: token)
    token
  end

  def self.find_by_session_token(token)
    joins(:tokens).where(user_tokens: {token: token})
  end
end
