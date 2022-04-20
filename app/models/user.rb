# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_many :tokens, class_name: "UserToken", dependent: :delete_all

  validates :password, presence: true, length: (8..72)

  def active_sessions
    tokens.where(context: UserToken.contexts[:session])
  end
end
