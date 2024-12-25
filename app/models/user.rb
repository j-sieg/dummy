# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_many :tokens, class_name: "UserToken", dependent: :delete_all

  has_many :expenses, dependent: :destroy

  validates :email, uniqueness: true
  validates :password, presence: true, length: (8..72)

  scope :confirmed, -> { where.not(confirmed_at: nil) }
  scope :unconfirmed, -> { where(confirmed_at: nil) }

  def active_sessions
    tokens.where(context: UserToken::CONTEXTS[:session])
  end

  def confirmation_tokens
    tokens.where(context: UserToken::CONTEXTS[:confirmation])
  end

  def change_email_tokens
    tokens.where("starts_with(context, 'change:')")
  end

  def confirm!
    update_column :confirmed_at, Time.current
  end
end
