class UserToken < ApplicationRecord
  belongs_to :user
  has_secure_token length: 36

  RANDOM_BYTE_SIZE = 32
  TOKEN_HASH_ALGO = "SHA256"
  CONTEXTS = {
    session: "session",
    confirmation: "confirmation",
    password_reset: "password_reset",
    user_invite: "user_invite"
  }.freeze

  # Used for storing encoded tokens for temporary access before
  # it's hashed and persisted. We use this for password-reset
  # tokens. The encoded_token is used in the email while the
  # hashed version is persisted in the database. The token is
  # passed into the hash function and compared to the persisted
  # version for verification.
  attr_accessor :encoded_token

  class << self
    # We don't need to hash the token like we do for password resets
    # because it's stored in the session which is encrypted and signed.
    def create_session_token!(user)
      record = UserToken.create!(user: user, context: CONTEXTS[:session])
      record.token
    end

    def create_change_email_token!(user, new_email)
      context = "change:#{user.email}"
      create_hashed_token!(user, context, new_email)
    end

    def create_confirmation_token!(user)
      create_hashed_token!(user, CONTEXTS[:confirmation], user.email)
    end

    def create_reset_password_token!(user)
      create_hashed_token!(user, CONTEXTS[:password_reset], user.email)
    end

    def find_user_by_session_token(token)
      User.confirmed.joins(:tokens).find_by(user_tokens: {token: token, context: CONTEXTS[:session]})
    end

    def find_user_by_invite_token(token)
      User.confirmed.joins(:tokens).find_by(user_tokens: {token: token, context: CONTEXTS[:user_invite]})
    end

    def find_user_by_reset_password_token(token)
      hashed_token = build_hashed_token_from_encoded_token(token)
      record =
        UserToken
          .includes(:user)
          .where(created_at: reset_password_valid_time_range)
          .find_by(token: hashed_token, context: CONTEXTS[:password_reset])

      if record && record.sent_to == record.user.email
        record.user
      end

    # Mostly just "invalid base64"s
    rescue ArgumentError => exception
      nil
    end

    def find_user_by_confirmation_token(token)
      hashed_token = build_hashed_token_from_encoded_token(token)
      record =
        UserToken
          .includes(:user)
          .where(created_at: confirmation_token_valid_time_range)
          .find_by(token: hashed_token, context: CONTEXTS[:confirmation])

      if record && record.sent_to == record.user.email
        record.user
      end

    # Mostly just "invalid base64"s
    rescue ArgumentError => exception
      nil
    end

    def find_record_by_user_change_email_token(user, token)
      hashed_token = build_hashed_token_from_encoded_token(token)
      context = "change:#{user.email}"

      UserToken.includes(:user).find_by(token: hashed_token, context: context)
    end

    def create_hashed_token!(user, context, sent_to = nil)
      encoded_token, hashed_token = build_hashed_token
      create!(
        user: user,
        sent_to: sent_to,
        context: context,
        token: hashed_token,
        encoded_token: encoded_token
      )
    end

    # Returns a urlsafe base64 encoded token that can be used
    # for user consumption and a hashed token for database storage.
    def build_hashed_token
      raw_token = SecureRandom.bytes(RANDOM_BYTE_SIZE)
      hashed_token = OpenSSL::Digest.digest(TOKEN_HASH_ALGO, raw_token)
      encoded_token = Base64.urlsafe_encode64(raw_token)

      [encoded_token, hashed_token]
    end

    def build_hashed_token_from_encoded_token(encoded_token)
      decoded_token = Base64.urlsafe_decode64(encoded_token)
      OpenSSL::Digest.digest(TOKEN_HASH_ALGO, decoded_token)
    end

    def reset_password_valid_time_range
      1.hour.ago..
    end

    def confirmation_token_valid_time_range
      3.days.ago..
    end
  end
end
