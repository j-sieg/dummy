# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_many :tokens, class_name: "UserToken", dependent: :delete_all

  # Users can invite many users
  has_many :user_invites_as_inviter, class_name: "UserInvite", foreign_key: :inviter_id, dependent: :nullify
  has_many :invited_users, through: :user_invites_as_inviter, source: :invited

  # Users can only be invited once so they only have one inviter
  has_one :user_invite, class_name: "UserInvite", foreign_key: :invited_id, dependent: :nullify
  has_one :inviter, through: :user_invite, source: :inviter

  has_one :invitation_token, through: :tokens

  validates :email, uniqueness: true
  validates :password, presence: true, length: (8..72)

  scope :confirmed, -> { where.not(confirmed_at: nil) }
  scope :unconfirmed, -> { where(confirmed_at: nil) }

  def invite_token
    tokens.where(context: UserToken::CONTEXTS[:user_invite]).first_or_create
  end

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
