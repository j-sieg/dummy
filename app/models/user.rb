# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_many :tokens, class_name: "UserToken", dependent: :delete_all

  validates :password, presence: true, length: (8..72)

  scope :confirmed, -> { where.not(confirmed_at: nil) }
  scope :unconfirmed, -> { where(confirmed_at: nil) }

  def active_sessions
    tokens.where(context: UserToken.contexts[:session])
  end

  def confirmation_tokens
    tokens.where(context: UserToken.contexts[:confirmation])
  end

  def confirm!
    update_column :confirmed_at, Time.current
  end
end
