# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_many :tokens, class_name: "UserToken"

  def self.find_by_session_token(token)
    joins(:tokens).find_by(user_tokens: {token: token})
  end

  def create_session_token!
    user_token_record = tokens.create!(context: UserToken.contexts[:session])
    user_token_record.token
  end

  def active_sessions
    tokens.where(context: UserToken.contexts[:session])
  end
end
